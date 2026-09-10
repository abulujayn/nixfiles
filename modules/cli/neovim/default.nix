{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gcc
    gnumake
    tree-sitter
    lazygit
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
