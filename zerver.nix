{ config, installer, lib, pkgs, ... }:

let
  installerConfig = installer.config;
  installerBuild = installerConfig.system.build;
  installerKernel = "${installerBuild.kernel}/${installerConfig.system.boot.loader.kernelFile}";
  installerInitrd = "${installerBuild.netbootRamdisk}/initrd";
in

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.extraFiles = {
    "efi/nixos-installer/linux" = installerKernel;
    "efi/nixos-installer/initrd" = installerInitrd;
  };
  boot.loader.systemd-boot.extraEntries."nixos-installer.conf" = ''
    title    26.05 Live
    sort-key o_nixos-installer
    linux    /efi/nixos-installer/linux
    initrd   /efi/nixos-installer/initrd
    options  init=${installerBuild.toplevel}/init ${lib.concatStringsSep " " installerConfig.boot.kernelParams}
  '';
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      Match Address 100.64.0.0/10
        PasswordAuthentication yes
      Match all
        PasswordAuthentication no
    '';
  };

  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  virtualisation.podman.enable = true;

  users.users.abulujayn = {
    isNormalUser = true;
    createHome = true;
    linger = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

  system.autoUpgrade = {
    enable = true;
    flags = [ "--update-input" "nixpkgs" ];
  };
}
