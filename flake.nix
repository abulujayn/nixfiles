{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

      globalModule = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      mkHost = host: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs username;
          nixpkgsInput = nixpkgs;
        };

        modules = [
          home-manager.nixosModules.home-manager
          globalModule

          {
            networking.hostName = host;
            system.autoUpgrade.flake = "github:abulujayn/nixfiles#${host}";
          }

          ./hosts/${host}/config.nix
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

          {
            networking.hostName = host;
            networking.computerName = host;
            networking.localHostName = host;
          }

          ./hosts/${host}/config.nix
        ];
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [
        "titan"
        "a01"
        "a02"
        "a03"
      ] mkHost;

      darwinConfigurations.mbp = mkDarwinHost "mbp";
    };
}
