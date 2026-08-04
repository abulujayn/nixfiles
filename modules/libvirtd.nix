{ pkgs, username, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    dbus.enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  networking.firewall.trustedInterfaces = [
    "virbr0"
  ];

  users.users = {
    ${username}.extraGroups = [ "libvirtd" ];
    libvirtdbus.extraGroups = [ "libvirtd" ];
  };
}
