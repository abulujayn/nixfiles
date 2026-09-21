{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-completion-generator = {
      url = "github:RobSis/zsh-completion-generator";
      flake = false;
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      settings = import ./settings.nix;
      inherit (settings) username;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      hosts = {
        a01 = {
          modules = [ ];
        };
        a02 = {
          modules = [ ];
        };
        a03 = {
          modules = [ ];
        };
      };

      homeManagerModule = { config, ... }: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${username} = {
            home = {
              inherit username;
              inherit (settings) stateVersion;
              homeDirectory = config.users.users.${username}.home;
            };

            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
          };
        };
      };

      sharedModules = [
        home-manager.nixosModules.home-manager
        homeManagerModule
        ./modules/system-base.nix
        ./modules/networking.nix
        ./modules/openssh.nix
        ./modules/tailscale.nix
        ./modules/nix-maintenance.nix
        ./modules/user-environment.nix
        ./modules/recovery-boot.nix
        ./modules/git.nix
        ./modules/neovim.nix
        ./modules/zsh.nix
      ];

      mkHost =
        hostname: host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs settings username;
            nixpkgsInput = nixpkgs;
          };

          modules =
            sharedModules
            ++ [
            ./hosts/${hostname}/hardware.nix

            {
              networking.hostName = hostname;
              system.autoUpgrade.flake = "github:abulujayn/nixfiles#${hostname}";
            }
          ]
            ++ host.modules;
        };

    in
    {
      formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      checks = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          lint =
            pkgs.runCommand "nixfiles-lint"
              {
                nativeBuildInputs = [
                  pkgs.deadnix
                  pkgs.statix
                ];
              }
              ''
                cd ${self}
                deadnix --fail --no-lambda-pattern-names .
                statix check --ignore 'hosts/*/hardware.nix' .
                touch $out
              '';
        }
      );

      devShells = nixpkgs.lib.genAttrs systems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nil
            nixd
            nixfmt
            deadnix
            statix
          ];
        };
      });

      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;
    };
}
