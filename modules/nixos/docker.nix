{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
    # Periodically prune Podman resources
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };
  };

  environment.systemPackages = with pkgs; [
    distrobox
    dive
    podman-tui
    docker-compose
    podman-compose
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  hardware.nvidia-container-toolkit.enable = true;
}
