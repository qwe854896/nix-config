{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
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
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }

        # multiple utilities
        ".local/share"
        ".local/state"

        # misc
        ".config/fcitx5"
        ".config/pulse"
        ".pki"
        ".steam"

        # vscode
        ".vscode"
        ".vscode-insiders"
        ".vscode-server"
        ".config/Code/User"
        ".config/Code - Insiders/User"

        # browsers
        ".mozilla"
        ".config/BraveSoftware"

        # sunshine
        ".config/sunshine"

        # password-store
        ".password-store"
      ];
    };
  };

  # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking
  # https://github.com/nix-community/disko/issues/312
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.services.snapshot = {
    description = "Snapshot the root filesystem";
    wantedBy = ["initrd.target"];
    requires = ["dev-mapper-encrypted.device"];
    after = ["dev-mapper-encrypted.device"];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /btrfs_tmp
      mount /dev/mapper/encrypted /btrfs_tmp
      if [[ -e /btrfs_tmp/@root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/@root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/@root
      umount /btrfs_tmp
    '';
  };
}
