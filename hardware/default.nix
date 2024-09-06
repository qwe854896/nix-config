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
}
