{ config, lib, pkgs, username, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
    ../../modules/efi-live.nix
    ../../modules/cockpit.nix
    ../../modules/libvirtd.nix
  ];

  home-manager.users.${username}.programs.zsh.initContent =
    lib.mkAfter "source ${./battery-prompt.zsh}";

  services.openssh.extraConfig = ''
    Match Address 172.16.97.1
      PasswordAuthentication yes
  '';

  # for nvidia stuff
  nixpkgs.config.allowUnfree = true;

  services.cockpit.plugins = [ pkgs.cockpit-machines ];
  services.cockpit.allowed-origins = [ "http://100.125.195.123:9090" ];
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
