{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-completion-generator = {
      url = "github:RobSis/zsh-completion-generator";
      flake = false;
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ... }:
    let
      username = "abulujayn";

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
          ./modules/cli

          {
            networking.hostName = host;
            system.autoUpgrade.flake = "github:abulujayn/nixfiles#${host}";
          }

          ./hosts/${host}
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
          ./modules/cli/git.nix
          ./modules/cli/zsh

          {
            networking.hostName = host;
            networking.computerName = host;
            networking.localHostName = host;
          }

          ./hosts/${host}
        ];
      };
    in
    {
      devShells = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ] (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nil
            nixd
          ];
        };
      });

      nixosConfigurations = nixpkgs.lib.genAttrs [
        "a01"
        "a02"
        "a03"
      ] mkHost;

      darwinConfigurations.mbp = mkDarwinHost "mbp";
    };
}
