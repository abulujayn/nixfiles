{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote

    ./hardware.nix
    ./disk.nix

    ../../modules/gui
    ../../modules/winvm.nix
  ];
}
