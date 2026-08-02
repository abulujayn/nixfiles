{ inputs, pkgs, ... }:

let
  helium = pkgs.callPackage ../../darwin-apps/helium.nix { };
in

{
  environment.systemPackages = [
    helium
  ];

  homebrew.casks = [
    "citrix-workspace"
    "google-drive"
    "google-gemini"
  ];
}
