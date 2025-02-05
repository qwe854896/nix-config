{
  self,
  pkgs,
  ...
}: {
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    defaults = {
      menuExtraClock.Show24Hour = true;

      finder = {
        _FXSortFoldersFirst = true;
        _FXShowPosixPathInTitle = true; # show full path in finder title

        FXDefaultSearchScope = "SCcf";
        FXRemoveOldTrashItems = true;

        AppleShowAllExtensions = true; # show all file extensions
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension

        QuitMenuItem = true; # enable quit menu item

        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;

        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };

      screencapture = {
        target = "clipboard";
        location = "~/Desktop";
        type = "png";
      };

      WindowManager = {
        GloballyEnabled = true;
        EnableStandardClickToShowDesktop = true;
        StandardHideDesktopIcons = false;
        StandardHideWidgets = false;
        HideDesktop = false;
        StageManagerHideWidgets = true;
      };

      controlcenter.Sound = true;

      trackpad = {
        TrackpadThreeFingerDrag = true;
      };

      dock = {
        autohide = false; # don't automatically hide and show the dock
        show-recents = false; # do not show recent apps in dock
        mru-spaces = false; # do not automatically rearrange spaces based on most recent use.
        expose-group-apps = true; # Group windows by application
        launchanim = true;
        orientation = "bottom";

        tilesize = 32;
        largesize = 128;
        magnification = true;

        /*
        * `1`: Disabled
        * `2`: Mission Control
        * `3`: Application Windows
        * `4`: Desktop
        * `5`: Start Screen Saver
        * `6`: Disable Screen Saver
        * `7`: Dashboard
        * `10`: Put Display to Sleep
        * `11`: Launchpad
        * `12`: Notification Center
        * `13`: Lock Screen
        * `14`: Quick Note
        */
        wvous-tl-corner = 13;
        wvous-tr-corner = 12;
        wvous-bl-corner = 11;
        wvous-br-corner = 4;
      };

      NSGlobalDomain = {
        # `defaults read NSGlobalDomain "xxx"`
        "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
        "com.apple.sound.beep.volume" = 0.69;
        "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key

        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        ApplePressAndHoldEnabled = false;

        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.spaces" = {
          # Display have separate spaces
          #   true => disable this feature
          #   false => enable this feature
          "spans-displays" = false;
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;
      };

      loginwindow = {
        GuestEnabled = false; # disable guest user
        SHOWFULLNAME = false; # show full name in login window
      };
    };

    keyboard = {
      enableKeyMapping = true; # enable key mapping so that we can use `option` as `control`

      # NOTE: do NOT support remap capslock to both control and escape at the same time
      remapCapsLockToControl = false; # remap caps lock to control, useful for emac users
      remapCapsLockToEscape = false; # remap caps lock to escape, useful for vim users

      # swap left command and left alt
      # so it matches common keyboard layout: `ctrl | command | alt`
      #
      # disabled, caused only problems!
      swapLeftCommandAndLeftAlt = false;

      userKeyMapping = [
        # remap escape to caps lock
        # so we swap caps lock and escape, then we can use caps lock as escape
        # {
        #   HIDKeyboardModifierMappingSrc = 30064771113;
        #   HIDKeyboardModifierMappingDst = 30064771129;
        # }
      ];
    };
    defaults.hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
  };

  time.timeZone = "Asia/Taipei";

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
  ];
}
