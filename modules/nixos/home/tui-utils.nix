{pkgs, ...}: let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  # Shell
  programs.bash.enable = true;
  programs.fish.enable = true;

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration = true;
  };

  programs.zellij.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.shellAliases = shellAliases;

  home.sessionVariables = {
    BROWSER = "brave";
  };
}
