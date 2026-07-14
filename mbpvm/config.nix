{ config, lib, pkgs, ... }:

{
  networking.hostName = "mbp";

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#mbpvm";
}
