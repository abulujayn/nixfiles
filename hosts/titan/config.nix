{ config, lib, pkgs, ... }:

{
  networking.hostName = "titan";
  system.autoUpgrade.flake = "github:abulujayn/nixfiles#titan";

  home-manager.users.abulujayn.programs.zsh.initContent =
    lib.mkAfter "source ${./battery-prompt.zsh}";

  services.openssh.extraConfig = ''
    Match Address 172.16.97.1
      PasswordAuthentication yes
  '';

  # for nvidia stuff
  nixpkgs.config.allowUnfree = true;

  services.cockpit = {
    enable = true;
    plugins = [ pkgs.cockpit-machines ];
    allowed-origins = [
      "http://titan:9090"
      "http://100.125.195.123:9090"
    ];
    settings.WebService.AllowUnencrypted = true;
  };

  # cockpit-machines uses virt-install and virt-xml to create and edit guests.
  environment.systemPackages = [ pkgs.virt-manager ];

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
