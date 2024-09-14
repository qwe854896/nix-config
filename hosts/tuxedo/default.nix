{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (import ./disko.nix {device = "/dev/disk/by-id/nvme-eui.0000000001000000e4d25c345e805201";})
    ./hardware-configuration.nix
    ./impermanence.nix
    ./secureboot.nix
    ./configuration.nix
  ];
}
