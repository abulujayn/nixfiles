{ pkgs, ... }:

{
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  environment.systemPackages = [
    pkgs.podman-compose
  ];
}
