{
  lib,
  pkgs,
  ...
}: {
  boot.loader.systemd-boot = {
    # we use Git for version control, so we don't need to keep too many generations.
    configurationLimit = lib.mkDefault 10;
    # pick the highest resolution for systemd-boot's console.
    consoleMode = lib.mkDefault "max";
  };

  # for power management
  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower.enable = true;
  };

  # Workaround for enabling systemd user atuind service
  systemd.user.services.atuind = {
    enable = true;

    environment = {
      ATUIN_LOG = "info";
    };
    serviceConfig = {
      ExecStart = "${pkgs.atuin}/bin/atuin daemon";
    };
    after = ["network.target"];
    wantedBy = ["default.target"];
  };
}
