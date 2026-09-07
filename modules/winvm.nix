{ inputs, pkgs, username, ... }:

{
  programs.virt-manager.enable = true;

  environment.systemPackages = [
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  # temporary fix as the directory isn't being created by default for some reason
  systemd.tmpfiles.rules = [
    "d /var/lib/swtpm-localca 0750 tss tss -"
  ];

  users.users.${username}.extraGroups = [ "libvirtd" ];
}
