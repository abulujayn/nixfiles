{ lib, ... }:

{
  imports = [ ../../battery-prompt/common.nix ];

  programs.zsh.interactiveShellInit =
    lib.mkOrder 950 "source ${./battery-prompt.zsh}";
}
