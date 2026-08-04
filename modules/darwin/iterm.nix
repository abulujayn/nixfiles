{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.iterm2
  ];

  home-manager.users.${config.system.primaryUser}.home.file = {
    "Library/Application Support/iTerm2/DynamicProfiles/nix-profiles.json".source = ./iterm-profiles.json;
  };
}
