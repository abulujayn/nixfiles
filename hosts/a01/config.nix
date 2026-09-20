{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/roles/server.nix
  ];

  environment.systemPackages = with pkgs; [
    codex
  ];
}
