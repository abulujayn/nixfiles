# Baseline for a ThinkPad T14 Gen 7 (Intel), not generated on the machine.
# Verify the storage layout with nixos-generate-config before installation.
{ lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Prefer the latest packaged kernel for this recent Intel platform.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Lanzaboote installs signed boot artifacts in place of the normal
  # systemd-boot NixOS module.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";

    # This supports installation directly from the GitHub flake: the first
    # boot is unsigned, then keys are generated on the encrypted root and
    # prepared for firmware enrollment on the following boot.
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
  };

  # systemd-based initrd is required for TPM2-backed LUKS tokens.
  boot.initrd.systemd.enable = true;

  security.tpm2.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tools
    libfido2
  ];

  hardware.bluetooth.enable = true;
  # WebAuthn browsers access FIDO2 security keys through hidraw. Give only the
  # active local login session access, including for non-Yubico authenticators.
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", TAG+="uaccess"
  '';
  services.libinput.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  # TLP applies the ThinkPad battery charge thresholds at boot and after
  # resume. It replaces power-profiles-daemon, which conflicts with TLP.
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "thinkpad_acpi" ];
}
