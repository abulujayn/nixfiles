{ lib, ... }:

{
  disko.devices.disk.main = {
    type = "disk";

    # disko-install overrides this with `--disk main <device>`. Keeping an
    # invalid default makes accidentally running the destructive Disko script
    # without selecting a disk fail safely.
    device = lib.mkDefault "/dev/disk/by-id/REPLACE_WITH_THINKPAD_DISK";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        luks = {
          size = "100%";

          content = {
            type = "luks";
            name = "cryptroot";

            # With no passwordFile or keyFile, Disko interactively creates the
            # initial passphrase keyslot. The TPM2 token is enrolled only after
            # Secure Boot is active; see INSTALL.md.
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            };

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };
          };
        };
      };
    };
  };
}
