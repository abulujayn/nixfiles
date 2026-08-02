{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home-manager.users = {
    abulujayn = {
      xdg.configFile."nvim" = {
        source = ../config/nvim;
        recursive = true;
      };

      home.packages = with pkgs; [
        gcc
        gnumake
        tree-sitter
        lazygit
      ];
    };

    root = {
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
}
