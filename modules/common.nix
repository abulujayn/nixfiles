{ config, lib, pkgs, ... }:

{
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  services.resolved.enable = true;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      Match Address 100.64.0.0/10
        PasswordAuthentication yes
      Match all
        PasswordAuthentication no
    '';
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  virtualisation.podman.enable = true;

  users.users.abulujayn = {
    isNormalUser = true;
    createHome = true;
    linger = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

  system.autoUpgrade = {
    enable = true;
    flags = [ "--no-write-lock-file" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.abulujayn = {
      home.stateVersion = "26.05";

      home.username = "abulujayn";
      home.homeDirectory = "/home/abulujayn";

      programs.git = {
        enable = true;
        settings = {
          url."https://github.com/".insteadOf = [
            "gh:"
            "github:"
          ];
          user = {
            name = "abulujayn";
            email = "zaeem@parkar.au";
          };
        };
      };

      programs.gh = {
        enable = true;
        gitCredentialHelper = {
          enable = true;
          hosts = [ "github.com" ];
        };
      };

      home.packages = with pkgs; [
        fastfetch
        distrobox
      ];
    };
  };

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
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
