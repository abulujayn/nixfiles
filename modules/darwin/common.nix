{ config, pkgs, ... }:

let
  core-monitor = pkgs.callPackage ../../darwin-apps/core-monitor.nix { };
  jump-desktop = pkgs.callPackage ../../darwin-apps/jump-desktop.nix { };
in

{
  imports = [
    ./iterm
  ];

  environment.systemPackages = with pkgs; [
    core-monitor
    jump-desktop
    notunes

    zed-editor
    tailscale
    chatgpt
    iloader

    mole-cleaner
    android-tools
    step-cli
    _7zz
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
  ];

  homebrew = {
    enable = true;

    casks = [
      "aldente"
      "thaw"
      "notunes"
      "logitech-g-hub"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };
  };

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
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      CreateDesktop = false;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "icnv";
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
      type = "png";
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

    LaunchServices.LSQuarantine = false;

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };

      "com.apple.finder".WarnOnEmptyTrash = false;

      "com.apple.controlcenter" = {
        RemoteLiveActivitiesEnabled = false;
        "NSStatusItem VisibleCC WiFi" = true;
      };

      "com.apple.safari" = {
        IncludeDevelopMenu = true;
        AutoOpenSafeDownloads = false;
        HideSuggestionsEmptyItemView = true;
        HideStartPageRecentlyClosedTabsEmptyItemView = true;
        ShowSidebarInNewWindows = false;
        ShowSidebarInTopSites = false;
      };

      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };

      NSGlobalDomain = {
        WebKitDeveloperExtras = true;
      };
    };
  };

  system.activationScripts.postActivation.text = ''
    echo "Show the ~/Library folder"
    chflags nohidden ~/Library
  '';

  power.sleep.allowSleepByPowerButton = true;

  users.users.${username} = {
    createHome = true;
    home = "/Users/${username}";
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    primaryUser = username;
    stateVersion = 7;
  };
}
