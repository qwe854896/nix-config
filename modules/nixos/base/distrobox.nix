{pkgs, ...}: {
  # https://wiki.nixos.org/wiki/Distrobox
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = [pkgs.distrobox];
}
