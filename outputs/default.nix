{
  # deadnix: skip
  self,
  nixpkgs,
  nix-darwin,
  nix-homebrew,
  home-manager,
  disko,
  pre-commit-hooks,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  homebrew-jorgelog,
  sops-nix,
  ...
}@inputs:
let
  supportedSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

  # System builder with common modules
  mkSystem =
    {
      system,
      hostName,
      systemType,
      extraModules ? [ ],
    }:
    let
      lib =
        if systemType == "nixos" then
          nixpkgs.lib
        else if systemType == "darwin" then
          nix-darwin.lib
        else
          throw "Unsupported system type: ${systemType}";

      baseModules =
        if systemType == "nixos" then
          [
            disko.nixosModules.default
          ]
        else
          [ ];

      commonModules = [
        ../modules/${systemType}
        ../modules/${systemType}/home-manager.nix
        ../modules/shared
        ../secrets
        home-manager."${systemType}Modules".home-manager
        {
          home-manager.extraSpecialArgs = inputs;
        }
        ../hosts/${hostName}
        sops-nix."${systemType}Modules".default
      ];
    in
    lib."${systemType}System" {
      inherit system;
      specialArgs = inputs // {
        inherit system;
      };
      modules = baseModules ++ commonModules ++ extraModules;
    };
in
{
  nixosConfigurations = {
    siber = mkSystem {
      systemType = "nixos";
      system = "x86_64-linux";
      hostName = "siber";
    };

    tuxedo = mkSystem {
      systemType = "nixos";
      system = "x86_64-linux";
      hostName = "tuxedo";
    };
  };

  darwinConfigurations = {
    siamese = mkSystem {
      systemType = "darwin";
      system = "aarch64-darwin";
      hostName = "siamese";
      extraModules = [
        nix-homebrew.darwinModules.nix-homebrew
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
    };
  };

  # Formatter and development shells
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

  checks = forAllSystems (system: {
    pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        nixfmt.enable = true;
        typos = {
          enable = true;
          settings = {
            write = true;
            configPath = "./.typos.toml";
          };
        };
        prettier = {
          enable = true;
          settings = {
            write = true;
            configPath = "./.prettierrc.yaml";
          };
        };
      };
    };
  });

  devShells = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          bashInteractive
          nixfmt
          deadnix
          statix
          typos
          nodePackages.prettier
        ];
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };
    }
  );
}
