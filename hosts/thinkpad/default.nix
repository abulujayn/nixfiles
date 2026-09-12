{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ../../overlays/noctalia.nix)
    (import ../../packages/libratbag.nix)
    (import ../../packages/iloader.nix { inherit inputs; })
  ];

  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote

    ./hardware.nix
    ./disk.nix

    ../../modules/console.nix
    ../../modules/gui
    ../../modules/winvm.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
    bubblewrap
    iloader
  ];

  services.flatpak.enable = true;
  services.ratbagd.enable = true;
  services.usbmuxd.enable = true;
}
