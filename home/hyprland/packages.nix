{pkgs, ...}: {
  # Packages
  home.packages = with pkgs; [
    # Hyprland Ecosystem
    hyprpicker

    # Wayland
    waybar # the status bar
    wofi # menu for wayland compositors
    mako # the notification daemon

    # Control
    brightnessctl
    playerctl
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
}
