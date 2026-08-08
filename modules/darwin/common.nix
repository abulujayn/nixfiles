{ username, ... }:

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

  services.openssh.enable = true;

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
