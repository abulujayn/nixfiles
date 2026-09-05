# ThinkPad installation

This layout erases the selected disk and creates a 1 GiB EFI System
Partition followed by an ext4 root filesystem inside LUKS2. It does not create
swap.

Before installing, back up any data, enable the TPM in firmware, put Secure
Boot into Setup Mode, and leave Secure Boot enforcement disabled for the first
boot. Boot the NixOS installer in UEFI mode and identify the target disk using
its stable ID:

```console
ls -l /dev/disk/by-id/
lsblk
```

Install directly from a tested GitHub revision. The name `main` corresponds to
`disko.devices.disk.main` in `disk.nix`:

```console
sudo nix run 'github:nix-community/disko/latest#disko-install' -- \
  --write-efi-boot-entries \
  --flake 'github:abulujayn/nixfiles/<commit>#thinkpad' \
  --disk main /dev/disk/by-id/<disk-id>
```

Disko prompts twice for the initial LUKS passphrase. This passphrase remains a
recovery keyslot after TPM enrollment. Do not store it in this repository.

## Establish Secure Boot

On the first boot, enter the LUKS passphrase. Lanzaboote generates Secure Boot
keys under `/var/lib/sbctl` on the encrypted root and prepares them for
automatic firmware enrollment. Check that both services succeeded:

```console
sudo systemctl status generate-sb-keys.service prepare-sb-auto-enroll.service
sudo sbctl status
```

Reboot once more. systemd-boot enrolls the prepared keys while the firmware is
in Setup Mode. Keep the default Microsoft certificates included by Lanzaboote;
some firmware and option ROMs require them. After the reboot, verify both the
firmware state and signatures:

```console
bootctl status
sudo sbctl status
sudo sbctl verify
```

Do not enroll the TPM keyslot until `bootctl status` reports Secure Boot as
enabled. PCR 7 changes when Secure Boot is enabled, so enrolling earlier would
seal the key against the wrong state.

## Add TPM2 unlock

Once Secure Boot is enabled, add a TPM2 token sealed to PCR 7. Use the physical
LUKS partition, not `/dev/mapper/cryptroot`:

```console
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/disk/by-partlabel/disk-main-luks
```

Enter the existing LUKS passphrase when prompted. This adds a new TPM-backed
unlock token; it does not remove the passphrase keyslot. Confirm both are
present before rebooting:

```console
sudo cryptsetup luksDump /dev/disk/by-partlabel/disk-main-luks
```

The next normal boot should unlock through the TPM. If the TPM state or Secure
Boot policy changes, the initrd falls back to the retained passphrase. Firmware
resets and some firmware or Secure Boot key changes can require TPM
re-enrollment; remove only the TPM token and repeat the command above rather
than wiping passphrase slots.
