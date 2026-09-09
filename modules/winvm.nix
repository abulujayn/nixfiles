{ pkgs, username, ... }:

{
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    dnsmasq
    virt-viewer
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      vhostUserPackages = [
        pkgs.virtiofsd
      ];
    };
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # temporary fix as the directory isn't being created by default for some reason
  systemd.tmpfiles.rules = [
    "d /var/lib/swtpm-localca 0750 tss tss -"
  ];

  users.users.${username}.extraGroups = [ "libvirtd" ];
}
