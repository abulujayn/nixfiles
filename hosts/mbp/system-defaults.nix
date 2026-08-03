{ config, inputs, pkgs, ... }:

{
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;

      persistent-apps = [
        "/Applications/Safari.app"
        "${pkgs.iterm2}/Applications/iTerm2.app"
        "${pkgs.zed-editor}/Applications/Zed.app"
        "/System/Applications/System Settings.app"
      ];

      persistent-others = [
        { folder = "/Users/${config.system.primaryUser}/Downloads"; }
      ];
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;

      AppleInterfaceStyleSwitchesAutomatically = true;

      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;

      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      "com.apple.keyboard.fnState" = true;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;

      "com.apple.sound.beep.feedback" = 0;
    };

    controlcenter = {
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
    };

    loginwindow.GuestEnabled = false;

    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
      ShowDate = 2; # never
    };

    screencapture = {
      location = "~/Downloads";
      save-selections = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadCornerSecondaryClick = 2; # bottom right
      TrackpadFourFingerHorizSwipeGesture = 2; # swipe between apps/spaces
      TrackpadFourFingerPinchGesture = 2;
      TrackpadPinch = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerHorizSwipeGesture = 1; # swipe between pages
      TrackpadThreeFingerVertSwipeGesture = 0; # disabled
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3; # open notification center
    };

    universalaccess = {
      closeViewScrollWheelToggle = true;
      closeViewZoomFollowsFocus = true;
    };
  };
}
