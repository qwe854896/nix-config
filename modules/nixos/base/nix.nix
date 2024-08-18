{
  lib,
  nixpkgs,
  ...
}: {
  # to install chrome, you need to enable unfree packages
  nixpkgs.config.allowUnfree = lib.mkForce true;

  nix = {
    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    # Manual optimise storage: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    settings.auto-optimise-store = true;

    channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
  };
}
