{ lib, username, ... }:

{
  imports = [
    ../../modules/darwin/common.nix

    ./work.nix
  ];

  home-manager.users.${username}.programs.zsh.initContent =
    lib.mkOrder 950 "source ${./battery-prompt.zsh}";
}
