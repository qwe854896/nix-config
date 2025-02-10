{
  description = "flake for nixos";

  outputs = inputs: import ./outputs inputs;

  # The nixConfig here only affects the flake itself, not the system configuration!
  # For more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # Official NixOS package sources, using unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix modules for Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew installation manager for nix-darwin
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-jorgelog = {
      url = "github:jorgelbg/homebrew-tap";
      flake = false;
    };

    # Home-Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Pre-install vscode-server
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    # Add git hooks to format nix code before commit
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Secrets Management
    sops-nix.url = "github:Mic92/sops-nix";

    # My private secrets, it's a private repository, you need to replace it with your own.
    # Use ssh protocol to authenticate via ssh-agent/ssh-key, and shallow clone to save time
    mysecrets = {
      url = "git+ssh://git@github.com/qwe854896/nix-secrets.git?shallow=1";
      flake = false;
    };

    # nixvim.url = "github:qwe854896/nixvim";
    nixvim.url = "github:elythh/nixvim";
  };
}
