{ config, pkgs, username, ... }:

{
  imports = [
    ../../modules/darwin/common.nix
    ../../modules/zsh.nix

    ./work.nix
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    primaryUser = username;
    stateVersion = 7;
  };

  users.users.${username} = {
    createHome = true;
    home = "/Users/${username}";
  };

  environment.systemPackages = with pkgs; [
    zed-editor
    tailscale
    chatgpt
    iloader

    mole-cleaner
    android-tools
    step-cli
    _7zz
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      home.stateVersion = "26.05";
      home.username = username;
      home.homeDirectory = config.users.users.${username}.home;

      programs.git = {
        enable = true;
        settings = {
          url."https://github.com/".insteadOf = [
            "gh:"
            "github:"
          ];
          user = {
            name = username;
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
    };
  };

  power.sleep.allowSleepByPowerButton = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
