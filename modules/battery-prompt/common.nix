{ lib, ... }:

{
  programs.zsh.interactiveShellInit =
    lib.mkOrder 940 "source ${./common.zsh}";
}
