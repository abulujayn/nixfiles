{ pkgs, ... }:

let
  aldente = pkgs.callPackage ../../darwin-apps/aldente.nix { };
  core-monitor = pkgs.callPackage ../../darwin-apps/core-monitor.nix { };
  notunes = pkgs.callPackage ../../darwin-apps/notunes.nix { };
  thaw = pkgs.callPackage ../../darwin-apps/thaw.nix { };
in

{
  imports = [
    ../../modules/zsh.nix

    ./system-defaults.nix
    ./pam.nix

    ./homebrew.nix
    ./work.nix
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    primaryUser = "abulujayn";
    stateVersion = 7;
  };

  users.users.abulujayn = {
    createHome = true;
    home = "/Users/abulujayn";
  };

  environment.systemPackages = [
    aldente
    core-monitor
    notunes
    thaw
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.abulujayn = {
      home.stateVersion = "26.05";
      home.username = "abulujayn";
      home.homeDirectory = "/Users/abulujayn";

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
        zed-editor
        iterm2
        tailscale
        chatgpt
        keepassxc
        iloader

        mole-cleaner
        android-tools
        step-cli
      ];
    };
  };

  power.sleep.allowSleepByPowerButton = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
