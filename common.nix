{ config, lib, pkgs, ... }:

{
  system.stateVersion = "26.05";

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.abulujayn = {
      home.stateVersion = "26.05";

      home.username = "abulujayn";
      home.homeDirectory = "/home/abulujayn";

      programs.git.settings = {
        url."https://github.com/".insteadOf = "gh:";
        user = {
          name = "abulujayn";
          email = "zaeem@parkar.au";
        };
      };

      xdg.configFile."nvim" = {
        source = ./config/nvim;
        recursive = true;
      };

      home.packages = with pkgs; [
        fastfetch
        distrobox

        gcc
        gnumake
        tree-sitter
        lazygit
      ];
    };
  };

  programs = {
    git.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
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
}
