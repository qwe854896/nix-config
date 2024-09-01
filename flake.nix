{
  description = "flake for nixos";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # Official NixOS package sources, using unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Pre-install vscode-server
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    # Add git hooks to format nix code before commit
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };
}
