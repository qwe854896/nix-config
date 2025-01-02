{pkgs, ...}: {
  # Packages
  home.packages = with pkgs; [
    # Hyprland Ecosystem
    hyprpicker

    # Wayland
    waybar # the status bar
    wofi # menu for wayland compositors
    mako # the notification daemon
    wl-clipboard

    # Control
    brightnessctl
    playerctl

    # Screenshot
    hyprshot
    grim # needed by flameshot when using wayland
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
}
