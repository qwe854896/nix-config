{inputs, ...}: {
  home.stateVersion = "24.05";

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname github.com
        IdentityFile ~/.ssh/jhc
        IdentitiesOnly yes
    '';
  };
}
