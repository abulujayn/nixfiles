{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.iterm2
  ];

  system.defaults.CustomUserPreferences."com.googlecode.iterm2" = {
    TabStyleWithAutomaticOption = 5;
    QuitWhenAllWindowsClosed = 1;
    PromptOnQuit = 0;
    HideTab = 0;
  };

  home-manager.users.${config.system.primaryUser}.home.file = {
    "Library/Application Support/iTerm2/DynamicProfiles/nix-profiles.json".source = ./iterm-profiles.json;
  };
}
