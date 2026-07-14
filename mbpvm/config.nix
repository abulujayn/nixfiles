{ config, lib, pkgs, ... }:

{
  networking.hostName = "mbpvm";
  services.resolved.enable = true;

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#mbpvm";
}
