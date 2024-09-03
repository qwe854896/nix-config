{pkgs, ...}: {
  # Browsers
  programs.firefox.enable = true;
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };

  # IDE
  programs.vscode = {
    enable = true;
  };

  # Media Player
  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    scripts = [pkgs.mpvScripts.mpris];
    config = {
      hwdec = "auto-safe";
    };
  };
}
