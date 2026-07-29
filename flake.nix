{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-completion-generator = {
      url = "github:RobSis/zsh-completion-generator";
      flake = false;
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.titan = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgsInput = nixpkgs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/titan/config.nix
        ];
      };

      nixosConfigurations.mbpvm = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgsInput = nixpkgs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/mbpvm/config.nix
        ];
      };

      nixosConfigurations.a01 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgsInput = nixpkgs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/a01/config.nix
        ];
      };

      nixosConfigurations.a02 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgsInput = nixpkgs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/a02/config.nix
        ];
      };

      nixosConfigurations.a03 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgsInput = nixpkgs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/a03/config.nix
        ];
      };
    };
}
