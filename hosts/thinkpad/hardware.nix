# Baseline for a ThinkPad T14 Gen 7 (Intel), not generated on the machine.
# Verify the storage layout with nixos-generate-config before installation.
{ lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Prefer the latest packaged kernel for this recent Intel platform.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  services.libinput.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.power-profiles-daemon.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "vmd" "usbhid" "thunderbolt" ];
  boot.kernelModules = [ "kvm-intel" "thinkpad_acpi" ];
}
