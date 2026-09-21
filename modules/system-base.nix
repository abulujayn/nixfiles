{ settings, ... }:

{
  system.stateVersion = settings.stateVersion;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = settings.timeZone;
  i18n.defaultLocale = settings.locale;
}
