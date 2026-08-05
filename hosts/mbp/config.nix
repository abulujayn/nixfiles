{ config, pkgs, username, ... }:

{
  imports = [
    ../../modules/darwin/common.nix
    ../../modules/zsh.nix

    ./work.nix
  ];
}
