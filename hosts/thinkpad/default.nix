{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote

    ./hardware.nix
    ./disk.nix
    ./secure-boot.nix

    ../../modules/gui
  ];
}
