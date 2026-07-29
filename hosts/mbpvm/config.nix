{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/efi-live.nix
  ];

  services.openssh.extraConfig = ''
    Match Address 172.16.97.1
      PasswordAuthentication yes
  '';
}
