{ config, lib, pkgs, ... }:

{
  networking.hostName = "z03.zerv.top";

  system.autoUpgrade.flake = "github:abulujayn/nixfiles#z03";
}
