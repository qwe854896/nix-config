_: {
  imports = [
    ./nix.nix
  ];
  programs = {
    # https://discourse.nixos.org/t/fish-shell-plugins-missing-from-profile-on-one-machine-but-not-on-another/21636
    zsh.enable = true;
    fish.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };
  # https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365/3
  documentation.man.generateCaches = false;
}
