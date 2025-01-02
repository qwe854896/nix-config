{
  config,
  pkgs,
  sops-nix,
  lib,
  ...
}: let
  user = "jhcheng";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
in {
  imports = [
    ../../modules/darwin/dock
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [
      emacs-unstable
      sops-nix.packages."${pkgs.system}".default
    ]
    ++ (import ../../modules/shared/packages.nix {inherit pkgs;});

  launchd.user.agents.emacs.path = [config.environment.systemPath];
  launchd.user.agents.emacs.serviceConfig = {
    KeepAlive = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
    ];
    StandardErrorPath = "/tmp/emacs.err.log";
    StandardOutPath = "/tmp/emacs.out.log";
  };

  home-manager = {
    users.${user} = _: {
      home = {
        file = {
          "emacs-launcher.command".source = myEmacsLauncher;
        };
      };
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
}
