{ inputs, pkgs, username, ... }:

{
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
    dnsmasq
    freerdp
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # temporary fix as the directory isn't being created by default for some reason
  systemd.tmpfiles.rules = [
    "d /var/lib/swtpm-localca 0750 tss tss -"
  ];

  users.users.${username}.extraGroups = [ "libvirtd" ];
}
