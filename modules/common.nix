{
  config,
  lib,
  pkgs,
  settings,
  username,
  ...
}:

{
  system.stateVersion = settings.stateVersion;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = settings.timeZone;
  i18n.defaultLocale = settings.locale;

  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  services = {
    resolved.enable = true;

    tailscale = {
      enable = true;
      extraSetFlags = [ "--ssh" ];
    };

    openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
      };
      extraConfig = lib.mkAfter ''
        Match all
          PasswordAuthentication no
      '';
    };
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  virtualisation.podman.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    linger = true;
    uid = settings.user.uid;
    extraGroups = [ "wheel" ];
  };

  system.autoUpgrade = {
    enable = true;
    flags = [ "--no-write-lock-file" ];
  };

  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 5 --keep-since 7d --no-direnv";
    };
  };

  home-manager.users.${username}.home.packages = with pkgs; [
    fastfetch
    distrobox
  ];

  environment.systemPackages = with pkgs; [
    wget
    curl
    gawk
    ripgrep
    gnugrep
    jq
    unzip
    less
    fd
    tree

    python314
    python314Packages.pip

    btop
    tmux
    kitty.terminfo
  ];

}
