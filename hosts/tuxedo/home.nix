{inputs, ...}: {
  home.stateVersion = "24.05";

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname github.com
        IdentityFile ~/.ssh/tuxedo
        IdentitiesOnly yes

      Host siber
        Hostname siber.feline
        IdentityFile ~/.ssh/tuxedo
        IdentitiesOnly yes
    '';
  };
}
