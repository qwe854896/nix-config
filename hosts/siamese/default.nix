{
  config,
  pkgs,
  sops-nix,
  lib,
  ...
}:
let
  user = "jhcheng";
in
{
  imports = [
    ../../modules/darwin/dock
  ];

  # Auto upgrade nix package and the daemon service.
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = [
    sops-nix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  home-manager = {
    users.${user} = _: {
      programs.ssh = {
        enable = true;
        extraConfig = ''
          Host github.com
            IdentityFile ~/.ssh/jhc@mba
            IdentitiesOnly yes
        '';
      };
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      entries = [
        { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
        { path = "/Applications/iTerm.app/"; }
        { path = "/Applications/Brave Browser.app/"; }
        { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/"; }
        { path = "/Applications/Zen.app/"; }
        { path = "/Applications/Telegram.app/"; }
        { path = "/Applications/Signal.app/"; }
        { path = "/Applications/Vesktop.app/"; }
        { path = "/Applications/Joplin.app/"; }
        { path = "/Applications/Moonlight.app/"; }
        { path = "/Applications/Visual Studio Code.app/"; }
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
