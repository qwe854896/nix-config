{
  config,
  pkgs,
  mysecrets,
  ...
}: let
  user = "jhcheng";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
  additionalFiles = import ./files.nix {inherit user config pkgs;};
in {
  imports = [
    ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = pkgs.callPackage ./brews.nix {};
    casks = pkgs.callPackage ./casks.nix {};
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)

    masApps = {
      "RunCat" = 1429033973;
      "wireguard" = 1451685025;
      "Messenger" = 1480068668;
    };
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
          {"emacs-launcher.command".source = myEmacsLauncher;}
        ];

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

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      entries = [
        {path = "${pkgs.alacritty}/Applications/Alacritty.app/";}
        {path = "/Applications/iTerm.app/";}
        {path = "/Applications/Brave Browser.app/";}
        {path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/";}
        {path = "/Applications/Firefox.app/";}
        {path = "/Applications/Telegram.app/";}
        {path = "/Applications/Discord.app/";}
        {path = "/Applications/Messenger.app/";}
        {path = "/Applications/Joplin.app/";}
        {path = "/Applications/Moonlight.app/";}
        {path = "/Applications/Visual Studio Code.app/";}
        {
          path = toString myEmacsLauncher;
          section = "others";
        }
        {
          path = "${config.users.users.${user}.home}/.local/share/";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
        {
          path = "${config.users.users.${user}.home}/Downloads/";
          section = "others";
          options = "--sort name --view grid --display stack";
        }
      ];
    };
  };

  # TODO: separate to suitable config
  # https://github.com/LnL7/nix-darwin/wiki/Terminfo-issues
  environment = {
    etc = {
      terminfo = {
        source = "${pkgs.ncurses}/share/terminfo";
      };
    };

    systemPackages = [
      pkgs.ncurses
    ];
  };
}
