{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/efi-live.nix
    ../../modules/ts-exitnode.nix
  ];

  networking.hostName = "a03";
  system.autoUpgrade.flake = "github:abulujayn/nixfiles#a03";
}
