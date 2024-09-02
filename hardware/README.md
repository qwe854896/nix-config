# How to deploy this flake

## Partitioning and Installation (With LUKS Encryption)

1. Enter Live CD and cd into `/tmp` directory, which is the only writable directory. For convenience, you can run `sudo su` to become root.
2. Create `/tmp/secret.key` as the LUKS passphrase. Using `echo -n <YOUR_PASSWORD_HERE> > /tmp/secret.key` is the easiest way.
3. Place `/tmp/disko.nix` here, and run `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"<YOUR_DISK_DEVICE_NAME_HERE>"'`.
4. After the partitioning is done, the root filesystem will be mounted at `/mnt`. You can run `nixos-generate-config --no-filesystems --root /mnt` to generate the hardware configuration.
5. Place all your nix files into `/mnt/etc/nixos/` and comment out `secureboot.nix` and `impermanence.nix` imports in `configuration.nix` to temporarily disable them. Modify `hardware-configuration.nix` to fit both the hardware and your needs.
6. Run `nixos-install --root /mnt --no-root-password --flake /mnt/etc/nixos#<YOUR_CONF_NAME_HERE>` to install the system without a root password.
7. Reboot into the installed system, enter the passphrase you specified in `/tmp/secret.key` to unlock the disk.

## Enabling Impermanence

1. Remove the comment in `configuration.nix` to enable `impermanence.nix` import. Run `nixos-rebuild switch` to enable impermanence.
2. Go around and fix file permissions as needed.

## Enabling Secure Boot

1. To enable secure boot, run `sbctl create-keys` and then remove the comment in `configuration.nix` to enable `secureboot.nix` import. Run `nixos-rebuild switch` to enable secure boot.
2. Next, enroll the keys by running `sbctl enroll-keys --microsoft`, which will enroll the keys to the UEFI firmware.

## Enabling TPM

1. Run `systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 <YOUR_CRYPTED_DEVICE_NAME_HERE>`

## References

- [Secure Boot & TPM-backed Full Disk Encryption on NixOS](https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/#tpm-unlock-of-root-partition)
