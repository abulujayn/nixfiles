{ pkgs, username, ... }:

{
  # Nix owns the shell and plugin packages; all interactive configuration is
  # loaded from the user's dotfiles under $ZDOTDIR.
  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;

  # Expose packaged Zsh plugins at stable paths below /run/current-system/sw.
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    zsh-autosuggestions
    zsh-fast-syntax-highlighting
    zsh-history-substring-search
    zsh-powerlevel10k
  ];
}
