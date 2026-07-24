{ config, lib, pkgs, ... }:

{
  networking.hostName = "a02";
  system.autoUpgrade.flake = "github:abulujayn/nixfiles#a02";
}
