{ ... }:

{
  programs.command-not-found.enable = false;
  programs.nix-index-database.enable = true;
  programs.nix-index.enableZshIntegration = false;
}
