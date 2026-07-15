{ config, lib, pkgs, ... }:

{
  networking.hostName = "a01";

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#a01";
}
