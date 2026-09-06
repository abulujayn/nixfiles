{ pkgs, username, ... }:

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

  system.userFiles.${username}."Library/Application Support/iTerm2/DynamicProfiles/nix-profiles.json".source =
    pkgs.writeText "iterm-dynamic-profiles.json" (
      builtins.toJSON (import ./iterm-profiles.nix)
    );
}
