{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./gtk.nix
    ./packages.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true; # enable Hyprland

    # Settings
    settings = {
      env = [
        "NIXOS_OZONE_WL,1" # Optional, hint Electron apps to use Wayland:
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"

        # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];
      cursor = {
        no_hardware_cursors = true;
      };
    };

    # hyprland extra configs
    extraConfig = builtins.readFile ./conf/hyprland.conf;

    # Plugins
    plugins = [
    ];

    systemd.variables = ["--all"];
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
    package = pkgs.hyprlock.overrideAttrs (old: {
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

    "hypr/waybar" = {
      source = ./conf/waybar;
      recursive = true;
    };
  };
}
