{ config, lib, pkgs, ... }:

{
  networking.hostName = "z03";

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#z03";
}
