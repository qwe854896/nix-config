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
  name = "lix";

  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "modules/nixos/server/server.nix"
      "modules/nixos/server/lxc-container.nix"
      # host specific
      "hosts/lxc-${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/linux/core.nix"
    ];
  };

  systemArgs = modules // args;
in {
  # NixOS's configuration
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;
}
