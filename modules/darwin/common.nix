{ pkgs, username, ... }:

let
  datebar = pkgs.callPackage ../../darwin-apps/datebar.nix { };
in

{
  imports = [
    ./applications.nix
    ./dock.nix
    ./finder.nix
    ./input.nix
    ./iterm
    ./safari.nix
    ./system-defaults.nix
  ];

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };
  system.defaults.loginwindow.GuestEnabled = false;
  system.defaults.LaunchServices.LSQuarantine = false;

  power.sleep.allowSleepByPowerButton = true;
  system.activationScripts.postActivation.text = ''
    echo "Setting AC-connected sleep settings"
    /usr/bin/pmset -c sleep 0 lessbright 0

    echo "Setting battery sleep settings"
    /usr/bin/pmset -b sleep 15 lessbright 0
  '';

  services.openssh.enable = true;

  environment.systemPackages = [ datebar ];

  users.users.${username} = {
    createHome = true;
    home = "/Users/${username}";
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    primaryUser = username;
    stateVersion = 7;
  };
}
