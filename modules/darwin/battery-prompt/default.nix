{ lib, username, ... }:

{
  home-manager.users.${username}.programs.zsh.initContent =
    lib.mkOrder 950 "source ${./battery-prompt.zsh}";
}
