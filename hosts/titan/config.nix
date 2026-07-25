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
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  home-manager.users.abulujayn = {
    xdg.configFile."bspwm/lid-monitor.sh" = {
      executable = true;
      source = ./lid-monitor.sh;
    };

    home.packages = with pkgs; [
      acpid
    ];
  };
  services.acpid.enable = true;
}
