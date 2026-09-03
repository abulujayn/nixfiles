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

  users.users.${username}.extraGroups = [ "libvirtd" ];
}
