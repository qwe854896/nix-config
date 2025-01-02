{hyprland, ...}: {
  imports = [
    ./fcitx5
    ./git.nix
    ./gui-apps.nix
    ./hyprland
    ./kitty.nix
    ./packages.nix
    ./starship.nix
    ./tui-utils.nix
    ./xdg.nix
    hyprland.homeManagerModules.default
  ];
}
