{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./core.nix
    ./fhs.nix
    ./fonts.nix
    ./gui.nix
    ./hyprland.nix
    ./i18n.nix
    ./misc.nix
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./packages.nix
    ./peripherals.nix
    ./security.nix
    ./ssh.nix
    ./steam.nix
    ./sunshine.nix
    ./user-group.nix
    ./wireguard.nix
    ./zram.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.pipewire.lowLatency.enable = true;
}
