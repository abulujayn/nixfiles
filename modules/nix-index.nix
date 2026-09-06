{ config, lib, ... }:

{
  programs.command-not-found.enable = false;
  programs.nix-index-database.enable = true;
  programs.nix-index.enableZshIntegration = false;

  programs.zsh.interactiveShellInit = lib.mkOrder 650 ''
    source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh
  '';
}
