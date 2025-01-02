{
  mysecrets,
  sops-nix,
  lib,
  pkgs,
  ...
}: let
  mysecrets_path = builtins.toString mysecrets;

  noaccess = {
    mode = "0000";
    owner = "root";
  };

  high_security = {
    mode = "0500";
    owner = "root";
  };
in
  # user_readable = {
  #   mode = "0500";
  #   owner = "jhc";
  # };
  {
    sops = {
      # This will add secrets.yml to the nix store
      defaultSopsFile = "${mysecrets_path}/secrets.yaml";

      age = {
        # This will automatically import SSH keys as age keys
        sshKeyPaths = [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/persist/etc/ssh/ssh_host_ed25519_key")
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/etc/ssh/ssh_host_ed25519_key")
        ];
      };

      secrets = {
        hashedPassword =
          {
            neededForUsers = true;
          }
          // high_security;

        # .age means the decrypted file is still encrypted by age(via a passphrase)
        "jhcheng-gpg-subkeys.priv.age" =
          {
            format = "binary";
            sopsFile = "${mysecrets_path}/jhcheng-gpg-subkeys-2034-09-03.priv.age";
          }
          // noaccess;
      };
    };
  }
