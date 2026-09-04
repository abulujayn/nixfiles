{ lib, username, ... }:

{
  imports = [ ../../battery-prompt/common.nix ];

  home-manager.users.${username}.programs.zsh.initContent =
    lib.mkOrder 950 "source ${./battery-prompt.zsh}";
}
