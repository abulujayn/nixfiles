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

    users.root = {
      home.stateVersion = "26.05";

      programs.neovim.extraConfig = ''
        set tabstop=2 softtabstop=2 shiftwidth=2
        set expandtab
        set number ruler
        set autoindent smartindent
        syntax enable
        filetype plugin indent on
      '';
    };
  };

  programs = {
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
