{ inputs, pkgs, ... }:

{
  security.pam.service.sudo_local = {
    enable = true;

    reattach = true;
    touchIdAuth = true;
  };
}
