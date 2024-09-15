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
    };

    # hyprland extra configs
    extraConfig = builtins.readFile ./conf/hyprland.conf;

    # Plugins
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];

    systemd.variables = ["--all"];
  };

  # hyprland configs
  xdg.configFile = {
    "hypr/scripts" = {
      source = ./conf/scripts;
      recursive = true;
    };
  };
}
