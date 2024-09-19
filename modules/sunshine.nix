{
  config,
  pkgs,
  ...
}:
# ===============================================================================
#
# Sunshine: A self-hosted game stream server for Moonlight(Client).
# It's designed for game streaming, but it can be used for remote desktop as well.
#
# How to use(Web Console: <https://localhost:47990/>):
#  https://docs.lizardbyte.dev/projects/sunshine/en/latest/about/usage.html
#
# Check Service Status
#   systemctl --user status sunshine
# Check logs
#   journalctl --user -u sunshine --since "2 minutes ago"
#
# References:
#   https://github.com/LongerHV/nixos-configuration/blob/c7a06a2125673c472946cda68b918f68c635c41f/modules/nixos/sunshine.nix
#   https://github.com/RandomNinjaAtk/nixos/blob/fc7d6e8734e6de175e0a18a43460c48003108540/services.sunshine.nix
#
# ===============================================================================
let
  sunshine-cuda = pkgs.sunshine.override {cudaSupport = true;};
in {
  services.sunshine = {
    enable = true;
    package = pkgs.sunshine.override {cudaSupport = true;};
    capSysAdmin = true;
    openFirewall = true;
    autoStart = true;
  };
}
