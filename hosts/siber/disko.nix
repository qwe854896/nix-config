{device ? throw "Set this to your disk device, e.g. /dev/sda", ...}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            start = "1M";
            end = "512M";
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
            size = "100%";
            content = {
              type = "luks";
              name = "encrypted";
              settings.allowDiscards = true;
              passwordFile = "/tmp/secret.key";

              # encrypt the root partition with luks2 and argon2id, will prompt for a passphrase, which will be used to unlock the partition.
              # cryptsetup luksFormat
              extraFormatArgs = [
                "--type luks2"
                "--cipher aes-xts-plain64"
                "--hash sha512"
                "--iter-time 5000"
                "--key-size 256"
                "--pbkdf argon2id"
                # use true random data from /dev/random, will block until enough entropy is available
                "--use-random"
              ];
              extraOpenArgs = [
                "--timeout 10"
              ];
              content = {
                type = "btrfs";
                extraArgs = ["-f"];

                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                  };

                  "@persist" = {
                    mountOptions = ["noatime" "compress-force=zstd:1"];
                    mountpoint = "/persist";
                  };

                  "@nix" = {
                    mountOptions = ["noatime" "compress-force=zstd:1"];
                    mountpoint = "/nix";
                  };

                  "@tmp" = {
                    mountOptions = ["noatime" "compress-force=zstd:1"];
                    mountpoint = "/tmp";
                  };

                  "@swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "4096M";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
