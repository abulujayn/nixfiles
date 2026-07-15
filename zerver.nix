{ config, lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.netbootxyz.enable = true;
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
      PasswordAuthentication = false;
    };
    extraConfig = ''
      Match Address 100.64.0.0/10
        PasswordAuthentication yes
    '';
  };
  security.pam.services.sshd.unixAuth = true;

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
