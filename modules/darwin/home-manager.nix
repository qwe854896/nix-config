{
  config,
  pkgs,
  mysecrets,
  ...
}: let
  user = "jhcheng";
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
  additionalFiles = import ./files.nix {inherit user config pkgs;};
in {
  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        # Home Manager needs a bit of information about you and the
        # paths it should manage.
        username = "${user}";
        homeDirectory = "/Users/${user}";

        # `programs.git` will generate the config file: ~/.config/git/config
        # to make git use this config file, `~/.gitconfig` should not exist!
        #
        #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
        activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
          rm -f ${config.home.homeDirectory}/.gitconfig
        '';

        stateVersion = "23.11";
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
    };
  };
}
