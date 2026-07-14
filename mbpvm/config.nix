{ config, lib, pkgs, ... }:

{
  networking.hostName = "mbp";
  services.resolved.enable = true;

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#mbpvm";
}
