{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
    ../../modules/efi-live.nix
    ../../modules/ts-exitnode.nix
  ];
}
