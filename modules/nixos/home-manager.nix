{
  config,
  pkgs,
  mysecrets,
  ...
}: let
  user = "jhc";
  # additionalFiles = import ./files.nix {inherit user config pkgs;};
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
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

          # `programs.git` will generate the config file: ~/.config/git/config
          # to make git use this config file, `~/.gitconfig` should not exist!
          #
          #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
          activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
            rm -f ${config.home.homeDirectory}/.gitconfig
          '';

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

        manual.manpages.enable = true;
      }
      // (import ./home inputs);
  };
}
