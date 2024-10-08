# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
_: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tuxedo"; # Define your hostname.
  networking.defaultGateway = {
    address = "127.0.0.1";
    interface = "eno1";
  };
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
  ];
  networking.interfaces."eno1" = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = "127.0.0.1";
          prefixLength = 27;
        }
      ];
    };
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  home-manager = {
    users = {
      jhc = import ./home.nix;
    };
  };
}
