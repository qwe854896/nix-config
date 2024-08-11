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
  name = "Jun-Hongs-iMac-Pro";

  modules = {
    darwin-modules =
      (map mylib.relativeToRoot [
        # common
        "modules/darwin"
        # host specific
        "hosts/${name}"
      ])
      ++ [];

    home-modules = map mylib.relativeToRoot [
      # common
      "home/darwin"
      # host specific
      "hosts/${name}/home.nix"
    ];
  };

  systemArgs = modules // args;
in {
  # macOS's configuration
  darwinConfigurations.${name} = mylib.macosSystem systemArgs;
}
