{
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib; let
  cfgWayland = config.modules.desktop.wayland;
  cfgXorg = config.modules.desktop.xorg;
in {
  imports = [
    ./base
    ../base.nix

    ./desktop
  ];

  options.modules.desktop = {
    wayland = {
      enable = mkEnableOption "Wayland Display Server";
    };
    xorg = {
      enable = mkEnableOption "Xorg Display Server";
    };
  };

  config = mkMerge [
    (mkIf cfgWayland.enable {
      ####################################################################
      #  NixOS's Configuration for Wayland based Window Manager
      ####################################################################
      services = {
        xserver.enable = false;
        # Enable the KDE Plasma Desktop Environment.
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
        desktopManager.plasma6.enable = true;
      };
    })

    (mkIf cfgXorg.enable {
      ####################################################################
      #  NixOS's Configuration for Xorg Server
      ####################################################################

      services = {
        gvfs.enable = true; # Mount, trash, and other functionalities
        tumbler.enable = true; # Thumbnail support for images

        xserver = {
          enable = true;
          displayManager = {
            lightdm.enable = true;
            autoLogin = {
              enable = true;
              user = myvars.username;
            };
            # use a fake session to skip desktop manager
            # and let Home Manager take care of the X session
            defaultSession = "hm-session";
          };
          desktopManager = {
            runXdgAutostartIfNone = true;
            session = [
              {
                name = "hm-session";
                manage = "window";
                start = ''
                  ${pkgs.runtimeShell} $HOME/.xsession &
                  waitPID=$!
                '';
              }
            ];
          };
          # Configure keymap in X11
          xkb.layout = "us";
          xkb.variant = "";
        };
      };
    })
  ];
}
