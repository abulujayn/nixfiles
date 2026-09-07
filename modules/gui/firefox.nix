{ pkgs, username, ... }:

let
  # Pin the complete theme so relative CSS imports and icon paths stay intact.
  # https://github.com/KiKaraage/ArcWTF (MIT)
  arcwtf = pkgs.fetchFromGitHub {
    owner = "KiKaraage";
    repo = "ArcWTF";
    rev = "b87561d5ada2fe8c67fa9250f4fc2ee50568cc63";
    hash = "sha256-k0H6hY9QLiTZ41BPffZ71IdgPaGusACCQfJxKhVNh/k=";
  };
  nordPolarNightId = "{758478b6-29f3-4d69-ab17-c49fe568ed80}";
  # Mozilla Add-ons: Nord Polar Night Theme by christos (CC BY-SA 3.0).
  nordPolarNightXpi = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3786274/nord_polar_night_theme-1.18.xpi";
    sha256 = "3a871b7ad5f78fe929b14d12afca722155bf47382d94da53bc9db899b78ec34c";
  };
  profile = ".config/mozilla/firefox/default";
in
{
  programs.firefox = {
    enable = true;
    preferencesStatus = "user";

    policies.ExtensionSettings."${nordPolarNightId}" = {
      installation_mode = "force_installed";
      install_url = "file://${nordPolarNightXpi}";
    };

    preferences = {
      # Load the declaratively installed theme and select it at startup.
      "extensions.autoDisableScopes" = 0;
      "extensions.activeThemeID" = nordPolarNightId;

      # ArcWTF uses Firefox's native vertical tabs, not Sidebery.
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "uc.tweak.hide-newtab-logo" = true;

      # Keep the browser quiet and uncluttered.
      "browser.aboutConfig.showWarning" = false;
      "browser.compactmode.show" = true;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.showWeather" = false;
      "browser.newtabpage.activity-stream.system.showWeather" = false;
      "browser.newtabpage.enabled" = true;
      # Start on Firefox Home instead of restoring the previous session.
      "browser.startup.page" = 1;
      "browser.tabs.closeWindowWithLastTab" = false;
      "browser.tabs.loadInBackground" = true;
      "browser.tabs.warnOnClose" = true;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "extensions.pocket.enabled" = false;

      # Prefer native dark controls and smooth, predictable scrolling.
      "browser.theme.content-theme" = 0;
      "browser.theme.toolbar-theme" = 0;
      "general.smoothScroll" = true;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "ui.systemUsesDarkTheme" = 1;

      # Disable Mozilla telemetry, experiments, and promotional discovery.
      "app.shield.optoutstudies.enabled" = false;
      "browser.discovery.enabled" = false;
      "browser.ping-centre.telemetry" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
    };
  };

  # Firefox profile layout and chrome are inherently per-user. Preferences and
  # the Firefox package itself are system-wide above.
  system.userFiles.${username} = {
    ".config/mozilla/firefox/profiles.ini".source = ./config/firefox/profiles.ini;
    "${profile}/chrome/arcwtf".source = arcwtf;
    "${profile}/chrome/userChrome.css".source = ./config/firefox/userChrome.css;
    "${profile}/chrome/userContent.css".source = ./config/firefox/userContent.css;
  };

  system.userFilesCleanup.${username} = [
    "${profile}/extensions/${nordPolarNightId}.xpi"
    "${profile}/user.js"
  ];
}
