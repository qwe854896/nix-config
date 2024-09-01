{inputs, ...}: let
  mysecrets = builtins.toString inputs.mysecrets;

  noaccess = {
    mode = "0000";
    owner = "root";
  };

  high_security = {
    mode = "0500";
    owner = "root";
  };

  user_readable = {
    mode = "0500";
    owner = "jhc";
  };
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # This will add secrets.yml to the nix store
    defaultSopsFile = "${mysecrets}/secrets.yaml";

    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
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
          sopsFile = "${mysecrets}/jhcheng-gpg-subkeys-2027-08-22.priv.age";
        }
        // noaccess;
    };
  };
}
