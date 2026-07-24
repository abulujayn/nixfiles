{ config, lib, pkgs, ... }:

{
  networking.hostName = "mbpvm";
  system.autoUpgrade.flake = "github:abulujayn/nixfiles#mbpvm";

  services.openssh.extraConfig = ''
    Match Address 172.16.97.1
      PasswordAuthentication yes
  '';
}
