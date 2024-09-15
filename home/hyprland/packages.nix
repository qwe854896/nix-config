{pkgs, ...}: {
  # Packages
  home.packages = with pkgs; [
    waybar # the status bar
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
}
