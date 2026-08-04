{ config, pkgs, ... }:

{
  system.defaults.dock = {
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
}
