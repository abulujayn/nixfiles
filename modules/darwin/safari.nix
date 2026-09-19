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
      ShowFavoritesBar-v2 = true;
      DownloadsClearingPolicy = 1;
      ExtensionsEnabled = true;
    };

    NSGlobalDomain.WebKitDeveloperExtras = true;
  };
}
