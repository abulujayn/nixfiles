{ ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/roles/server.nix
  ];
}
