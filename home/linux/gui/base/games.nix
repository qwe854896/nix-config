{pkgs, ...}: {
  home.packages = with pkgs; [
    gamescope # SteamOS session compositing window manager
    prismlauncher # A free, open source launcher for Minecraft
    winetricks # A script to install DLLs needed to work around problems in Wine
  ];
}
