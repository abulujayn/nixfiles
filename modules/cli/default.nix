{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    gh
    git

    zsh-autosuggestions
    zsh-fast-syntax-highlighting
    zsh-history-substring-search
    zsh-powerlevel10k

    neovim
    gcc
    gnumake
    tree-sitter
    lazygit
  ];

  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
