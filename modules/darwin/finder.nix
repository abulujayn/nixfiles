{ ... }:

{
  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      CreateDesktop = false;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "icnv";
      _FXSortFoldersFirst = true;
      _FXShowPosixPathInTitle = false;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    WindowManager.EnableStandardClickToShowDesktop = false;

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };

      "com.apple.finder".WarnOnEmptyTrash = false;
    };
  };

  system.activationScripts.postActivation.text = ''
    echo "Show the ~/Library folder"
    chflags nohidden ~/Library
  '';
}
