{ installer, lib, ... }:

let
  installerConfig = installer.config;
  installerBuild = installerConfig.system.build;
  installerKernel = "${installerBuild.kernel}/${installerConfig.system.boot.loader.kernelFile}";
  installerInitrd = "${installerBuild.netbootRamdisk}/initrd";
in
{
  boot.loader.systemd-boot.extraFiles = {
    "efi/nixos-installer/linux" = installerKernel;
    "efi/nixos-installer/initrd" = installerInitrd;
  };

  boot.loader.systemd-boot.extraEntries."nixos-installer.conf" = ''
    title    Recovery 26.05
    sort-key o_nixos-installer
    linux    /efi/nixos-installer/linux
    initrd   /efi/nixos-installer/initrd
    options  init=${installerBuild.toplevel}/init ${lib.concatStringsSep " " installerConfig.boot.kernelParams}
  '';

  boot.zfs.forceImportRoot = false;
}
