# Baseline for a ThinkPad T14 Gen 7 (Intel), not generated on the machine.
# Verify the storage layout with nixos-generate-config before installation.
{ lib, pkgs, username, ... }:

let
  tpmFido = pkgs.buildGoModule {
    pname = "tpm-fido";
    version = "unstable-2026-03-05";

    src = pkgs.fetchFromGitHub {
      owner = "mc256";
      repo = "tpm-fido2-thinkpad-linux";
      rev = "49222c60dbbf0c5ec4356240cbd92789e41945da";
      hash = "sha256-eC5nsIYm3gLfs2vPU6Bo2L1D0mNWT2gOTq2aBe39jT0=";
    };

    vendorHash = "sha256-Q/FapUvEW/i7acfIPtlJqlTQ4/LKCeUJa3gU7xMX/C4=";

    buildPhase = ''
      runHook preBuild
      go build -o tpm-fido ./tpmfido.go
      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck
      go test ./...
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 tpm-fido "$out/bin/tpm-fido"
      runHook postInstall
    '';

    meta = {
      description = "TPM- and fingerprint-backed virtual FIDO2 authenticator";
      homepage = "https://github.com/mc256/tpm-fido2-thinkpad-linux";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      mainProgram = "tpm-fido";
    };
  };
in

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

  # tpm-fido creates a virtual FIDO2 HID device. The daemon runs only in the
  # desktop user's session; its keys remain in the TPM and each ceremony is
  # gated by fprintd fingerprint verification.
  users.groups.tpm-fido = { };
  users.users.${username}.extraGroups = [ "tpm-fido" "tss" ];
  systemd.user.services.tpm-fido = {
    description = "TPM-FIDO2 virtual security key";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.fprintd ];
    serviceConfig = {
      ExecStart = "${lib.getExe tpmFido} --mode=daemon --tray";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  hardware.bluetooth.enable = true;
  # WebAuthn browsers access FIDO2 security keys through hidraw. Give only the
  # active local login session access, including for non-Yubico authenticators.
  services.udev.extraRules = ''
    KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="tpm-fido", MODE="0660"
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
  boot.kernelModules = [ "kvm-intel" "thinkpad_acpi" "uhid" ];
}
