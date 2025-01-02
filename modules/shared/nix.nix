{
  lib,
  pkgs,
  nixpkgs,
  nixvim,
  ...
}: let
  emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";
in {
  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
      allowUnsupportedSystem = false;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let
        path = ../../overlays;
      in
        with builtins;
          map (n: import (path + ("/" + n))) (
            filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))) (
              attrNames (readDir path)
            )
          )
          ++ [
            (import (
              builtins.fetchTarball {
                url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
                sha256 = emacsOverlaySha256;
              }
            ))
          ]
          ++ [
            (final: prev: {
              neovim = nixvim.packages.${pkgs.system}.default;
            })
          ]
          ++ [
            (self: super: {
              bpftrace = super.bpftrace.override {
                llvmPackages = super.llvmPackages_18;
              };
            })
          ];
  };

  # Nix Settings
  nix = {
    settings = {
      # enable flakes globally
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # given the users in this list the right to specify additional substituters via:
      #    1. `nixConfig.substituers` in `flake.nix`
      #    2. command line args `--options substituers http://xxx`
      trusted-users = [
        "@wheel"
        "@admin"
        "jhc"
        "jhcheng"
      ];

      # the following will be considered before the official ones
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      # let remote cache server fetches as many build deps to reduce build times
      builders-use-substitutes = true;

      # Manual optimise storage: nix-store --optimise
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      # Enable this on Linux only, as it's unstable on macOS
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = pkgs.stdenv.hostPlatform.isLinux;

      # https://github.com/NixOS/nix/issues/9574
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    };

    # do garbage collection weekly to keep disk usage low
    gc =
      {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 7d";
      }
      // (
        if pkgs.stdenv.hostPlatform.isLinux
        then {
          dates = lib.mkDefault "weekly";
        }
        else {}
      )
      // (
        if pkgs.stdenv.hostPlatform.isDarwin
        then {
          user = "root";
          interval = {
            Weekday = 0;
            Hour = 2;
            Minute = 0;
          };
        }
        else {}
      );

    # auto upgrade nix to the unstable version
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
    package = pkgs.nixVersions.latest;
  };

  ### From https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry ###

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

  # discard all the default paths, and only use the one from this flake.
  nix.nixPath = lib.mkForce ["/etc/nix/inputs"];
}
