{ inputs, username }:

let
  inherit (inputs) home-manager nix-darwin nixpkgs;

  globalModule = { config, ... }: {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${username} = {
        home.stateVersion = "26.05";
        home.username = username;
        home.homeDirectory = config.users.users.${username}.home;

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
  };

  mkHost = host: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs username;
      nixpkgsInput = nixpkgs;
    };

    modules = [
      home-manager.nixosModules.home-manager
      globalModule
      ../modules/common.nix
      ../modules/cli

      {
        networking.hostName = host;
        system.autoUpgrade.flake = "github:abulujayn/nixfiles#${host}";
      }

      ../hosts/${host}
    ];
  };

  mkDarwinHost = host: nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs username;
      nixpkgsInput = nixpkgs;
    };

    modules = [
      home-manager.darwinModules.home-manager
      globalModule
      ../modules/cli/git.nix
      ../modules/cli/zsh

      {
        networking.hostName = host;
        networking.computerName = host;
        networking.localHostName = host;
      }

      ../hosts/${host}
    ];
  };
in
{
  inherit mkHost mkDarwinHost;
}
