{ lib, pkgs, ... }:

{
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
  ];
}
