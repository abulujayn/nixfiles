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
}
