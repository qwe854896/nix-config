{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.stateVersion = "24.05";

  home.persistence."/persist/home/jhc" = {
    directories = [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"

      # multiple utilities
      ".local/share"
      ".local/state"

      # misc
      ".config/fcitx5"
      ".config/pulse"
      ".pki"
      ".steam"

      # vscode
      ".vscode"
      ".vscode-insiders"
      ".vscode-server"
      ".config/Code/User"
      ".config/Code - Insiders/User"

      # browsers
      ".mozilla"
      ".config/BraveSoftware"

      # sunshine
      ".config/sunshine"

      # password-store
      ".password-store"
    ];

    files = [
    ];

    allowOther = true;
  };

  home.persistence."/persist/home/jhc/dotfiles/Plasma" = {
    directories = [
      ".config/gtk-3.0"
      ".config/gtk-4.0"
      ".config/kde.org"
      ".config/kdedefaults"
      ".config/xsettingsd"
    ];

    files = [
      ".gtkrc-2.0"
      ".config/akregatorrc"
      ".config/baloofilerc"
      ".config/dolphinrc"
      ".config/gtkrc"
      ".config/gtkrc-2.0"
      ".config/gwenviewrc"
      ".config/kactivitymanagerdrc"
      ".config/kateschemarc"
      ".config/katevirc"
      ".config/kcminputrc"
      ".config/kconf_updaterc"
      ".config/kded5rc"
      ".config/kdeglobals"
      ".config/kglobalshortcutsrc"
      ".config/khotkeysrc"
      ".config/klipperrc"
      ".config/kmixrc"
      ".config/konsolerc"
      ".config/konsolesshconfig"
      ".config/kscreenlockerrc"
      ".config/ksmserverrc"
      ".config/ktimezonedrc"
      ".config/kwalletrc"
      ".config/kwinrc"
      ".config/kwinrulesrc"
      ".config/kwritemetainfos"
      ".config/kwriterc"
      ".config/kxkbrc"
      ".config/okularpartrc"
      ".config/plasma-localerc"
      ".config/plasma-org.kde.plasma.desktop-appletsrc"
      ".config/plasmanotifyrc"
      ".config/plasmashellrc"
      ".config/powermanagementprofilesrc"
      ".config/spectaclerc"
      ".config/startkderc"
      ".config/systemsettingsrc"
      ".config/Trolltech.conf"
      ".config/user-dirs.dirs"
      ".config/user-dirs.locale"
      ".config/xdg-desktop-portal-kderc"
    ];

    allowOther = true;
  };
}
