{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fcitx5
    ./git.nix
    ./gui-apps.nix
    ./hyprland
    ./kitty.nix
    ./packages.nix
    ./password-store.nix
    ./starship.nix
    ./tui-utils.nix
    ./xdg.nix
    inputs.hyprland.homeManagerModules.default
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jhc";
  home.homeDirectory = "/home/jhc";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
