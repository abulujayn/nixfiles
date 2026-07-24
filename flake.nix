{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.titan = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsInput = nixpkgs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/common.nix
          ./modules/efi-live.nix

          ./hosts/titan/config.nix
          ./hosts/titan/hardware.nix
        ];
      };

      nixosConfigurations.mbpvm = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsInput = nixpkgs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/common.nix
          ./modules/efi-live.nix

          ./hosts/mbpvm/config.nix
          ./hosts/mbpvm/hardware.nix
        ];
      };

      nixosConfigurations.a01 = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsInput = nixpkgs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/common.nix
          ./modules/ts-exitnode.nix
          ./modules/efi-live.nix

          ./hosts/a01/config.nix
          ./hosts/a01/hardware.nix
        ];
      };

      nixosConfigurations.a02 = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsInput = nixpkgs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/common.nix
          ./modules/ts-exitnode.nix
          ./modules/efi-live.nix

          ./hosts/a02/config.nix
          ./hosts/a02/hardware.nix
        ];
      };

      nixosConfigurations.a03 = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsInput = nixpkgs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/common.nix
          ./modules/ts-exitnode.nix
          ./modules/efi-live.nix

          ./hosts/a03/config.nix
          ./hosts/a03/hardware.nix
        ];
      };
    };
}
