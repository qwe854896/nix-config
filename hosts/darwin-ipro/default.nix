_: let
  hostName = "ipro"; # Define your hostname.
in {
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  networking.hostName = hostName;
  networking.computerName = hostName;
  system.defaults.smb.NetBIOSName = hostName;

  system.stateVersion = 4;
}
