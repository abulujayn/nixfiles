{ pkgs, ... }:

let
  core-monitor = pkgs.callPackage ../../darwin-apps/core-monitor.nix { };
  jump-desktop = pkgs.callPackage ../../darwin-apps/jump-desktop.nix { };
in

{
  environment.systemPackages = with pkgs; [
    core-monitor
    jump-desktop

    zed-editor
    tailscale
    iloader
    raycast

    mole-cleaner
    android-tools
    step-cli
    _7zz
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
  ];

  homebrew = {
    enable = true;

    casks = [
      "aldente"
      "thaw"
      "notunes"
      "logitech-g-hub"
      "linearmouse"
      "chatgpt"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };
  };

  programs.mas = {
    enable = true;

    packages = {
      "Amphetamine" = 937984704;
      "Windows App" = 1295203466;
      "uBlock" = 6745342698;
      "AdBlock Pro" = 1018301773;
      "Xcode" = 497799835;
    };
  };
}
