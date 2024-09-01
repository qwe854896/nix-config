{pkgs, ...}: {
  # Shell
  programs.bash.enable = true;
  programs.fish.enable = true;

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname github.com
        IdentityFile ~/.ssh/jhc
        IdentitiesOnly yes
    '';
  };

  programs.zellij.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
