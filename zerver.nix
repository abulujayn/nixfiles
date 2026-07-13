{ config, lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;

  virtualisation.podman.enable = true;

  users.users.abulujayn = {
    isNormalUser = true;
    createHome = true;
    linger = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    initialPassword = "changemeplease";
  };

  system.autoUpgrade = {
    enable = true;
    flags = [ "--update-input" "nixpkgs" ];
  };
}
