{ ... }:

{
  system.defaults.CustomUserPreferences = {
    "com.apple.safari" = {
      IncludeDevelopMenu = true;
      AutoOpenSafeDownloads = false;
      HideSuggestionsEmptyItemView = true;
      HideStartPageRecentlyClosedTabsEmptyItemView = true;
      ShowSidebarInNewWindows = false;
      ShowSidebarInTopSites = false;
    };

    NSGlobalDomain.WebKitDeveloperExtras = true;
  };
}
