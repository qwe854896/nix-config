{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (import ./disko.nix {device = "/dev/vda";})
    ./hardware-configuration.nix
    ./impermanence.nix
    ./secureboot.nix
  ];

  # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking
  # https://github.com/nix-community/disko/issues/312
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.services.snapshot = {
    description = "Snapshot the root filesystem";
    wantedBy = ["initrd.target"];
    wants = ["dev-vg-root.device"];
    after = ["dev-vg-root.device"];
    before = ["-.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /btrfs_tmp
      mount /dev/vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
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

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };
}
