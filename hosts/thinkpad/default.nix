{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote

    ./hardware.nix
    ./disk.nix

    ../../modules/console.nix
    ../../modules/gui
    ../../modules/winvm.nix

    ./work.nix
  ];

  environment.systemPackages = with pkgs; [
    bubblewrap
    distrobox
  ];

  # Provides flatpak-spawn for distrobox-host-exec.
  services.flatpak.enable = true;
}
