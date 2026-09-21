{
  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.enable = true;
  };

  services.resolved.enable = true;
}
