{
  pkgs,
  lib,
  ...
}: let
  shellAliases = {
    "code" = "code-insiders --";
  };
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
  home.shellAliases = shellAliases;
  programs.vscode = {
    enable = true;
    package =
      (pkgs.vscode.override {
        isInsiders = true;

        # https://wiki.archlinux.org/title/Wayland#Electron
        commandLineArgs = [
          # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
          # (only supported by chromium/chrome at this time, not electron)
          "--gtk-version=4"
          # make it use text-input-v1, which works for kwin 5.27 and weston
          "--enable-wayland-ime"
        ];
      })
      .overrideAttrs (oldAttrs: rec {
        version = "latest";
        # Use VSCode Insiders to fix crash: https://github.com/NixOS/nixpkgs/issues/246509
        src = builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          sha256 = "1v250i7jipb2p5311y6q1ldnp58d2c5nifdl1c5bhidlkjcl651a";
        };
      });
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
