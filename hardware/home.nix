{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.stateVersion = "24.05";

  home.persistence."/persist/home/jhc" = {
    directories = [
      ".local/share"
      ".local/state"
    ];

    files = [
    ];

    allowOther = true;
  };
}
