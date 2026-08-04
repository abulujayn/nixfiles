{ ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;

      "com.apple.sound.beep.feedback" = 0;
    };

    loginwindow.GuestEnabled = false;

    screencapture = {
      location = "~/Downloads";
      save-selections = false;
    };
  };
}
