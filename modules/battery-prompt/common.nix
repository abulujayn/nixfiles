{ lib, username, ... }:

{
  home-manager.users.${username}.programs.zsh.initContent =
    lib.mkOrder 940 "source ${./common.zsh}";
}
