{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"

      "/var/log"
      "/var/lib"
      "/var/db/sudo/lectured"

      "/etc/secureboot"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  environment.persistence."/persist" = {
    users.jhc = {
      directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      jhc = import ./home.nix;
    };
    backupFileExtension = "backup";
  };
}
