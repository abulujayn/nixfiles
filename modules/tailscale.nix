{
  config,
  lib,
  ...
}:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--ssh"
      "--advertise-exit-node"
    ];
  };

  networking.firewall = {
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  assertions = [
    {
      assertion = config.services.tailscale.enable;
      message = "Tailscale must be enabled to advertise an exit node.";
    }
    {
      assertion = config.services.tailscale.useRoutingFeatures == "server";
      message = "Exit-node routing requires Tailscale server routing features.";
    }
    {
      assertion =
        toString config.boot.kernel.sysctl."net.ipv4.ip_forward" == "1"
        && toString config.boot.kernel.sysctl."net.ipv6.conf.all.forwarding" == "1";
      message = "Exit-node routing requires IPv4 and IPv6 forwarding.";
    }
    {
      assertion =
        lib.elem config.services.tailscale.interfaceName config.networking.firewall.trustedInterfaces
        && lib.elem config.services.tailscale.port config.networking.firewall.allowedUDPPorts;
      message = "Tailscale's interface and UDP port must be allowed by the firewall.";
    }
  ];
}
