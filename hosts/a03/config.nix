{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/efi-live.nix
    ../../modules/ts-exitnode.nix
  ];
}
