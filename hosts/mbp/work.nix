{ inputs, pkgs, ... }:

let
  helium = pkgs.callPackage ../../darwin-apps/helium.nix { };
in

{
  environment.systemPackages = with pkgs; [
    helium
    keepassxc
  ];

  homebrew.casks = [
    "citrix-workspace"
    "google-drive"
    "google-gemini"
  ];
}
