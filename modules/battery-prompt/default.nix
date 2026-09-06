{ lib, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh.interactiveShellInit =
    lib.mkOrder 950 "source ${./battery-prompt.zsh}";
}
