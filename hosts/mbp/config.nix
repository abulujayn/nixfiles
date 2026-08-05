{ config, pkgs, username, ... }:

{
  imports = [
    ../../modules/darwin/common.nix

    ./work.nix
  ];
}
