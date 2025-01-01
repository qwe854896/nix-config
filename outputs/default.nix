{
  # deadnix: skip
  self,
  nixpkgs,
  nix-darwin,
  nix-homebrew,
  home-manager,
  vscode-server,
  disko,
  pre-commit-hooks,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  homebrew-jorgelog,
  sops-nix,
  ...
} @ inputs: let
  supportedSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
in {
  nixosConfigurations = {
    siber = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules
        ../secrets
        ../hosts/siber

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = inputs;
            users.jhc = import ../home;
          };
        }

        vscode-server.nixosModules.default
        (_: {
          services.vscode-server.enable = true;
        })

        disko.nixosModules.default
        sops-nix.nixosModules.default
      ];
      specialArgs = inputs;
    };

    tuxedo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules
        ../secrets
        ../hosts/tuxedo

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = inputs;
            users.jhc = import ../home;
          };
        }

        vscode-server.nixosModules.default
        (_: {
          services.vscode-server.enable = true;
        })

        disko.nixosModules.default
        sops-nix.nixosModules.default
      ];
      specialArgs = inputs;
    };
  };

  darwinConfigurations = {
    siamese = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ../secrets
        ../hosts/siamese
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        sops-nix.darwinModules.default
        {
          nix-homebrew = {
            user = "jhcheng";
            enable = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "jorgelbg/homebrew-tap" = homebrew-jorgelog;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
      ];
      specialArgs = inputs;
    };
  };

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  checks = forAllSystems (system: {
    pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        alejandra.enable = true; # formatter
        typos = {
          enable = true;
          settings = {
            write = true; # Automatically fix typos
            configPath = "./.typos.toml"; # relative to the flake root
          };
        };
        prettier = {
          enable = true;
          settings = {
            write = true; # Automatically format files
            configPath = "./.prettierrc.yaml"; # relative to the flake root
          };
        };
        # deadnix.enable = true; # detect unused variable bindings in `*.nix`
        # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
      };
    };
  });

  devShells = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
          bashInteractive

          # Nix-related
          alejandra
          deadnix
          statix

          # spell checker
          typos

          # code formatter
          nodePackages.prettier
        ];
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };
    }
  );
}
