{ pkgs, username, ... }:

{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    env.LAZY = pkgs.vimPlugins.lazy-nvim;
    extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];
    extraFiles."lua/lazy_setup.lua".source = ./config/lua/lazy_setup.lua;
    extraFiles."neovim.yml".source = ./config/neovim.yml;
    extraFiles."selene.toml".source = ./config/selene.toml;
    extraConfigLua = builtins.readFile ./config/init.lua;

    extraPackages = with pkgs; [
      gcc
      gnumake
      tree-sitter
      lazygit
    ];
  };

  system.userFilesCleanup.${username} = [ ".config/nvim" ];
}
