{pkgs, ...}: {
  # Packages
  home.packages = with pkgs; [
    waybar # the status bar
    wofi # menu for wayland compositors
    mako # the notification daemon

    brightnessctl
    playerctl
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
}
