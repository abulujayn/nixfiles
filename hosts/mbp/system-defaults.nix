{ inputs, pkgs, ... }:

{
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;

      persistent-apps = [
        { app = "Safari"; }
        { app = "iTerm2"; }
        { app = "Zed"; }
        { app = "System Settings"; }
      ];

      persistent-others = [
        { folder = "/Users/@username@/Downloads"; }
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
      # 24 = don't show
      Bluetooth = 24;
      Display = 24;
      FocusMode = 24;
      NowPlaying = 24;
      Sound = 24;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
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
