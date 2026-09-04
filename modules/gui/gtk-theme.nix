{ pkgs, mkValue ? value: value }:

# The desktop sets these values directly; Thunar supplies overridable defaults.
{
  enable = true;
  colorScheme = mkValue "dark";

  theme = {
    package = mkValue pkgs.nordic;
    name = mkValue "Nordic";
  };

  iconTheme = {
    package = mkValue pkgs.nordzy-icon-theme;
    name = mkValue "Nordzy-dark";
  };
}
