{
  pkgs,
  lib,
  ...
}: let
in {
  # Browsers
  programs.firefox.enable = true;
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
      # (only supported by chromium/chrome at this time, not electron)
      "--gtk-version=4"
      # make it use text-input-v1, which works for kwin 5.27 and weston
      "--enable-wayland-ime"

      # enable hardware acceleration - vulkan api
      # "--enable-features=Vulkan"
    ];
  };

  # IDE
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      # https://wiki.archlinux.org/title/Wayland#Electron
      commandLineArgs = [
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=4"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"
      ];
    };
    extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      mkhl.direnv
    ];
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

  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
