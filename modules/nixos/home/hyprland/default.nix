{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./packages.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true; # enable Hyprland

    settings = {
      cursor = {
        no_hardware_cursors = true;
      };
    };

    # hyprland extra configs
    extraConfig = builtins.readFile ./conf/hyprland.conf;

    systemd.enable = false;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "pidof hyprlock || hyprlock";
        }
      ];
    };
  };

  services.swayosd.enable = true;

  programs.hyprlock = {
    enable = true;
    extraConfig = builtins.readFile ./conf/hyprlock.conf;

    # https://github.com/hyprwm/hyprlock/issues/128
    package = pkgs.hyprlock.overrideAttrs (_: {
      patchPhase = ''
        substituteInPlace src/core/hyprlock.cpp \
        --replace "5000" "16"
      '';
    });
  };

  # hyprland configs
  xdg.configFile = {
    "hypr/scripts" = {
      source = ./conf/scripts;
      recursive = true;
    };

    "waybar" = {
      source = ./conf/waybar;
      recursive = true;
    };

    "uwsm" = {
      source = ./conf/uwsm;
      recursive = true;
    };
  };
}
