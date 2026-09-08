{ config, pkgs, username, ... }:

let
  kvmfrSizeMb = 32;
in
{
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    dnsmasq
    looking-glass-client
  ];

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    kernelModules = [
      "kvmfr"
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
    ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=${toString kvmfrSizeMb}
    '';
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
  '';

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      vhostUserPackages = [
        pkgs.virtiofsd
      ];
      verbatimConfig = ''
        namespaces = []
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
          "/dev/rtc", "/dev/hpet", "/dev/vfio/vfio",
          "/dev/kvmfr0"
        ]
      '';
    };
  };

  systemd.services.arc-b390-vf = {
    description = "Create Arc B390 SR-IOV VF for Windows VM";

    wantedBy = [ "multi-user.target" ];
    before = [ "libvirtd.service" ];
    after = [ "systemd-modules-load.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      PF=/sys/bus/pci/devices/0000:00:02.0
      VF=/sys/bus/pci/devices/0000:00:02.1
      BDF=0000:00:02.1

      # Create one VF if it doesn't already exist
      if [ "$(cat "$PF/sriov_numvfs")" != "1" ]; then
        echo 0 > "$PF/sriov_numvfs"
        echo 1 > "$PF/sriov_numvfs"
      fi

      # Bind only the VF to vfio-pci
      echo vfio-pci > "$VF/driver_override"

      if [ -L "$VF/driver" ]; then
        echo "$BDF" > "$VF/driver/unbind"
      fi

      echo "$BDF" > /sys/bus/pci/drivers_probe
    '';
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # temporary fix as the directory isn't being created by default for some reason
  systemd.tmpfiles.rules = [
    "d /var/lib/swtpm-localca 0750 tss tss -"
  ];

  users.users.${username}.extraGroups = [
    "kvm"
    "libvirtd"
  ];
}
