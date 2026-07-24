{ config, lib, pkgs, ... }:

{
  services.tailscale = {
      useRoutingFeatures = "server";
      extraSetFlags = [
        "--advertise-exit-node"
      ];
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
}
