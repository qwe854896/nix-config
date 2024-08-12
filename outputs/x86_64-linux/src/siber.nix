{
  # NOTE: the args not used in this file CAN NOT be removed!
  # Because haumea passes arguments lazily,
  # and these arguments are used in other functions.
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "siber";

  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "modules/nixos/desktop.nix"
        # host specific
        "hosts/${name}"
      ])
      ++ [
      ];
    home-modules = map mylib.relativeToRoot [
      "home/linux/gui.nix"
      "hosts/${name}/home.nix"
    ];
  };

  modules-plasma6 = {
    nixos-modules =
      [
        {
          modules.desktop.wayland.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {
          modules.desktop.plasma6.enable = true;
        }
      ]
      ++ base-modules.home-modules;
  };
in {
  # NixOS's configuration
  nixosConfigurations = {
    # With KDE Plasma 6
    "${name}" = mylib.nixosSystem (modules-plasma6 // args);
  };

  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
