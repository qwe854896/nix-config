{pkgs-unstable, ...}: {
  # terminal file manager
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
