{
  config,
  lib,
  settings,
  ...
}:

{
  imports = [
    ../common.nix
    ../efi-live.nix
    ../neovim.nix
  ];

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  assertions = [
    {
      assertion = config.nixpkgs.hostPlatform.system == "aarch64-linux";
      message = "Server hosts must target aarch64-linux.";
    }
    {
      assertion = config.boot.loader.systemd-boot.enable && config.boot.loader.efi.canTouchEfiVariables;
      message = "Server hosts require a writable EFI systemd-boot configuration for recovery.";
    }
    {
      assertion =
        config.services.tailscale.enable
        -> (
          lib.elem config.services.tailscale.interfaceName config.networking.firewall.trustedInterfaces
          && lib.elem config.services.tailscale.port config.networking.firewall.allowedUDPPorts
        );
      message = "Tailscale must have its interface trusted and UDP port allowed by the firewall.";
    }
    {
      assertion = config.system.stateVersion == settings.stateVersion;
      message = "System stateVersion must come from settings.nix.";
    }
    {
      assertion = config.services.tailscale.enable;
      message = "Server hosts require Tailscale for exit-node advertising.";
    }
    {
      assertion = config.services.tailscale.useRoutingFeatures == "server";
      message = "Server hosts require Tailscale server routing features.";
    }
    {
      assertion =
        toString config.boot.kernel.sysctl."net.ipv4.ip_forward" == "1"
        && toString config.boot.kernel.sysctl."net.ipv6.conf.all.forwarding" == "1";
      message = "Server hosts require IPv4 and IPv6 forwarding for exit-node traffic.";
    }
  ];
}
