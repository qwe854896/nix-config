{pkgs, ...}: {
  imports = [
    ./core.nix
    ./fhs.nix
    ./fonts.nix
    ./i18n.nix
    ./misc.nix
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./packages.nix
    ./peripherals.nix
    ./plasma5.nix
    ./security.nix
    ./ssh.nix
    ./steam.nix
    ./sunshine.nix
    ./user-group.nix
    ./zram.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };
}
