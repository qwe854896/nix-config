{
  # deadnix: skip
  self,
  nixpkgs,
  ...
} @ inputs: let
  supportedSystems = ["x86_64-linux"];
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
in {
  nixosConfigurations = {
    siber = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules
        ../secrets
        ../hosts/siber

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.jhc = import ../home;
          };
        }

        inputs.vscode-server.nixosModules.default
        (
          _: {
            services.vscode-server.enable = true;
          }
        )

        inputs.disko.nixosModules.default
      ];
      specialArgs = {inherit inputs;};
    };

    tuxedo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules
        ../secrets
        ../hosts/tuxedo

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.jhc = import ../home;
          };
        }

        inputs.vscode-server.nixosModules.default
        (
          _: {
            services.vscode-server.enable = true;
          }
        )

        inputs.disko.nixosModules.default
      ];
      specialArgs = {inherit inputs;};
    };
  };

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  checks = forAllSystems (
    system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
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
    }
  );

  devShells = forAllSystems (system: let
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
  });
}
