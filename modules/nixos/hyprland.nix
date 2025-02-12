{
  pkgs,
  hyprland,
  ...
}: {
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
