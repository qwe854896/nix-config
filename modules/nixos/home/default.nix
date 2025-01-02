{hyprland, ...}: {
  imports = [
    ./fcitx5
    ./gui-apps.nix
    ./hyprland
    ./xdg.nix
    hyprland.homeManagerModules.default
  ];
}
