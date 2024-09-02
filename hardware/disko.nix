{device ? throw "Set this to your disk device, e.g. /dev/sda", ...}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            start = "1M";
            end = "128M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              # https://github.com/nix-community/disko/issues/527
              mountOptions = ["umask=0077"];
              mountpoint = "/boot";
            };
          };
          luks = {
            name = "crypted";
            size = "100%";
            content = {
              type = "luks";
              name = "root";
              settings.allowDiscards = true;
              passwordFile = "/tmp/secret.key";
              extraFormatArgs = [
                "--iter-time 1" # insecure but fast for tests
              ];
              content = {
                type = "lvm_pv";
                vg = "vg";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];

              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                };

                "/persist" = {
                  mountOptions = ["subvol=@persist" "compress-force=zstd:1"];
                  mountpoint = "/persist";
                };

                "/nix" = {
                  mountOptions = ["subvol=@nix" "noatime" "compress-force=zstd:1"];
                  mountpoint = "/nix";
                };

                "/tmp" = {
                  mountOptions = ["subvol=@tmp" "compress-force=zstd:1"];
                  mountpoint = "/tmp";
                };
              };
            };
          };
          swap = {
            size = "4G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
