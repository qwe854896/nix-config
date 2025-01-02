{
  config,
  pkgs,
  mysecrets,
  ...
}: let
  user = "jhc";
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
  # additionalFiles = import ./files.nix {inherit user config pkgs;};
in {
  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/home/${user}";
    shell = pkgs.zsh;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    } @ inputs:
      {
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix {};
          file = lib.mkMerge [
            sharedFiles
            # additionalFiles
          ];

          # Home Manager needs a bit of information about you and the
          # paths it should manage.
          username = "${user}";
          homeDirectory = "/home/${user}";

          stateVersion = "24.05";
        };
        programs =
          {}
          // import ../shared/home-manager.nix {
            inherit
              config
              pkgs
              lib
              mysecrets
              ;
          };

        # Marked broken Oct 20, 2022 check later to remove this
        # https://github.com/nix-community/home-manager/issues/3344
        manual.manpages.enable = false;
      }
      // (import ./home inputs);
  };
}
