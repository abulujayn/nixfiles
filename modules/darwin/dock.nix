{ config, ... }:

{
  system.defaults.dock = {
    autohide = true;
    show-recents = false;

    persistent-apps = [
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      "/Applications/Nix Apps/iTerm2.app"
      "/Applications/Nix Apps/Zed.app"
      "/Applications/ChatGPT.app"
      "/System/Applications/System Settings.app"
    ];

    persistent-others = [
      { folder = "/Users/${config.system.primaryUser}/Downloads"; }
    ];
  };
}
