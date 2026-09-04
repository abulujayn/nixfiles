{ username, ... }:

{
  system.defaults.dock = {
    autohide = true;
    show-recents = false;

    persistent-apps = [
      "/Applications/Firefox.app"
      "/Applications/Nix Apps/iTerm2.app"
      "/Applications/Nix Apps/Zed.app"
      "/Applications/ChatGPT.app"
      "/System/Applications/System Settings.app"
    ];

    persistent-others = [
      { folder = "/Users/${username}/Downloads"; }
    ];
  };
}
