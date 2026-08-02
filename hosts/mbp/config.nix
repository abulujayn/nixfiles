{ pkgs, ... }:

{
  imports = [
    ../../modules/zsh.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "abulujayn";

  users.users.abulujayn = {
    createHome = true;
    home = "/Users/abulujayn";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.abulujayn = {
      home.stateVersion = "26.05";
      home.username = "abulujayn";
      home.homeDirectory = "/Users/abulujayn";

      programs.git = {
        enable = true;
        settings = {
          url."https://github.com/".insteadOf = [
            "gh:"
            "github:"
          ];
          user = {
            name = "abulujayn";
            email = "zaeem@parkar.au";
          };
        };
      };

      programs.gh = {
        enable = true;
        gitCredentialHelper = {
          enable = true;
          hosts = [ "github.com" ];
        };
      };
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
