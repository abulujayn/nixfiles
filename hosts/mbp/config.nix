{ pkgs, ... }:

{
  imports = [
    ../../modules/zsh.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    primaryUser = "abulujayn";
    stateVersion = 6;
  };

  users.users.abulujayn.home = "/Users/abulujayn";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.abulujayn = {
      home.stateVersion = "26.05";
      home.username = "abulujayn";
      home.homeDirectory = "/Users/abulujayn";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
