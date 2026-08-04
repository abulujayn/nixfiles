{ ... }:

{
  system.defaults.trackpad = {
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

  system.defaults.universalaccess = {
    closeViewScrollWheelToggle = true;
    closeViewZoomFollowsFocus = true;
  };

  system.defaults.NSGlobalDomain = {
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    "com.apple.keyboard.fnState" = true;
  };
}
