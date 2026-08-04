{ ... }:

{
  system.defaults.NSGlobalDomain = {
    AppleICUForce24HourTime = true;
  };

  system.defaults.controlcenter = {
    Bluetooth = false;
    Display = false;
    FocusModes = false;
    NowPlaying = false;
    Sound = false;
  };

  system.defaults.menuExtraClock = {
    Show24Hour = true;
    ShowSeconds = true;
    ShowDate = 2; # never
  };
}
