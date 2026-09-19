{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    keepassxc
  ];

  homebrew.casks = [
    "citrix-workspace"
    "google-drive"
    "helium-browser"
  ];
}
