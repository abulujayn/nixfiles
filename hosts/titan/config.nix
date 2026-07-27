{ config, lib, pkgs, ... }:

{
  networking.hostName = "titan";
  system.autoUpgrade.flake = "github:abulujayn/nixfiles#titan";

  services.openssh.extraConfig = ''
    Match Address 172.16.97.1
      PasswordAuthentication yes
  '';

  # for nvidia stuff
  nixpkgs.config.allowUnfree = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
    IdleActionSec = "0";
  };

  services.acpid = {
    enable = true;
    handlers = {
      lid-close = {
        event = "button/lid.*close";
        action = ''
          echo off > /sys/class/drm/card1-eDP-1/status
        '';
      };
      lid-open = {
        event = "button/lid.*open";
        action = ''
          echo on > /sys/class/drm/card1-eDP-1/status
        '';
      };
    };
  };
}
