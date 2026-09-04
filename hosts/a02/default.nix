{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/efi-live.nix
    ../../modules/ts-exitnode.nix
  ];
}
