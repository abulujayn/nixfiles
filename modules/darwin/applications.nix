{ config, pkgs, ... }:

let
  amphetamine-power-protect = pkgs.callPackage ../../darwin-apps/amphetamine-power-protect.nix { };
  core-monitor = pkgs.callPackage ../../darwin-apps/core-monitor.nix { };
  jump-desktop = pkgs.callPackage ../../darwin-apps/jump-desktop.nix { };
in

{
  environment.systemPackages = with pkgs; [
    amphetamine-power-protect
    core-monitor
    jump-desktop

    zed-editor
    iloader
    raycast

    mole-cleaner
    android-tools
    step-cli
    _7zz
  ];

  environment.etc."sudoers.d/amphetamine_powerProtect".source =
    "${amphetamine-power-protect}/etc/sudoers.d/amphetamine_powerProtect";

  home-manager.users.${config.system.primaryUser} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.file = {
      "Library/Application Scripts/com.if.Amphetamine/powerProtect.scpt".source =
        "${amphetamine-power-protect}/Library/Application Scripts/com.if.Amphetamine/powerProtect.scpt";
    };
  };

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
      "tailscale-app"
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
