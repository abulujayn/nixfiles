{ config, pkgs, ... }:

let
  aldente = pkgs.callPackage ../../darwin-apps/aldente.nix { };
  core-monitor = pkgs.callPackage ../../darwin-apps/core-monitor.nix { };
  jump-desktop = pkgs.callPackage ../../darwin-apps/jump-desktop.nix { };
  notunes = pkgs.callPackage ../../darwin-apps/notunes.nix { };
  thaw = pkgs.callPackage ../../darwin-apps/thaw.nix { };
in

{
  imports = [
    ./iterm
  ];

  environment.systemPackages = [
    aldente
    core-monitor
    jump-desktop
    notunes
    thaw
  ];

  homebrew.enable = true;

  programs.mas = {
    enable = true;

    packages = {
      "Amphetamine" = 937984704;
      "Windows App" = 1295203466;
      "uBlock" = 6745342698;
      "Xcode" = 497799835;
    };
  };

  security.pam.services.sudo_local = {
    enable = true;

    reattach = true;
    touchIdAuth = true;
  };

  system.defaults = {
    controlcenter = {
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    dock = {
      autohide = true;
      show-recents = false;

      persistent-apps = [
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/System/Applications/Utilities/Terminal.app"
        "${pkgs.zed-editor}/Applications/Zed.app"
        "/System/Applications/System Settings.app"
      ];

      persistent-others = [
        { folder = "/Users/${config.system.primaryUser}/Downloads"; }
        { folder = "/Users/${config.system.primaryUser}/Library/Mobile Documents/com~apple~CloudDocs"; }
      ];
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
      _FXSortFoldersFirst = true;
      _FXShowPosixPathInTitle = false;
    };

    loginwindow.GuestEnabled = false;

    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
      ShowDate = 2; # never
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
      "com.apple.sound.beep.feedback" = 0;
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

    WindowManager.EnableStandardClickToShowDesktop = false;
  };
}
