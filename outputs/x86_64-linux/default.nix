{
  lib,
  inputs,
  ...
} @ args: let
  inherit (inputs) haumea;

  # Contains all the flake outputs of this system architecture.
  data = haumea.lib.load {
    src = ./src;
    inputs = args;
  };
  # nix file names is redundant, so we remove it.
  dataWithoutPaths = builtins.attrValues data;

  # Merge all the machine's data into a single attribute set.
  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) dataWithoutPaths);
    packages = lib.attrsets.mergeAttrsList (map (it: it.packages or {}) dataWithoutPaths);
  };
in
  outputs
  // {
    inherit data; # for debugging purposes
  }
