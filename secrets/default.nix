{inputs, ...}: let
  mysecrets = builtins.toString inputs.mysecrets;
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
      initialHashedPassword = {};

      # .age means the decrypted file is still encrypted by age(via a passphrase)
      "jhcheng-gpg-subkeys.priv.age" = {
        format = "binary";
        sopsFile = "${mysecrets}/jhcheng-gpg-subkeys-2027-08-22.priv.age";
      };
    };
  };
}
