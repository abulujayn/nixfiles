{ config, ... }:

{
  networking.firewall = {
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.tailscale.enable = true;

  services.openssh.extraConfig = ''
    Match Address 100.64.0.0/10
      PasswordAuthentication yes
    Match all
  '';

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
}
