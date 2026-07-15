{ config, lib, pkgs, ... }:

{
  networking.hostName = "a03";

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#a03";
}
