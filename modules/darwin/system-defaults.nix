{ ... }:

{
  system.defaults = {
    controlcenter = {
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
      ShowDate = 2; # never
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      "com.apple.sound.beep.feedback" = 0;
      AppleShowScrollBars = "WhenScrolling";
    };

    screencapture = {
      location = "~/Downloads";
      save-selections = false;
      type = "png";
    };

    CustomUserPreferences = {
      "com.apple.controlcenter" = {
        RemoteLiveActivitiesEnabled = false;
        "NSStatusItem VisibleCC WiFi" = true;
      };

      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };

      # disable spotlight
      "com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
        "64".enabled = false;
        "65".enabled = false;

        # Move space left (Ctrl+LeftArrow)
        "79" = {
          enabled = true;
          value = {
            type = "standard";
            parameters = [
              65535
              123
              262144
            ];
          };
        };
        # Move space right (Ctrl+RightArrow)
        "81" = {
          enabled = true;
          value = {
            type = "standard";
            parameters = [
              65535
              124
              262144
            ];
          };
        };
      };
    };
  };
}
