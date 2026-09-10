{ inputs, pkgs, ... }:

{
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
  ];

  # Provides flatpak-spawn for distrobox-host-exec.
  services.flatpak.enable = true;

  services.ratbagd.enable = true;
}
