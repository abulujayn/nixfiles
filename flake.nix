{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      installer = nixpkgs.lib.nixosSystem {
        modules = [
          ({ modulesPath, ... }: {
            imports = [
              (modulesPath + "/installer/netboot/netboot-minimal.nix")
            ];

            nixpkgs.hostPlatform = "aarch64-linux";
            system.stateVersion = "26.05";
          })
        ];
      };

    in
    {
      nixosConfigurations.mbpvm = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit installer; };
        modules = [
          home-manager.nixosModules.home-manager
          ./common.nix
          ./zerver.nix
          ./efi-live.nix
          ./mbpvm/config.nix
          ./mbpvm/hardware.nix
        ];
      };

      nixosConfigurations.a01 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit installer; };
        modules = [
          home-manager.nixosModules.home-manager
          ./common.nix
          ./zerver.nix
          ./ts-exitnode.nix
          ./efi-live.nix
          ./a01/config.nix
          ./a01/hardware.nix
        ];
      };

      nixosConfigurations.a02 = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          ./common.nix
          ./zerver.nix
          ./ts-exitnode.nix
          ./a02/config.nix
          ./a02/hardware.nix
        ];
      };

      nixosConfigurations.a03 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit installer; };
        modules = [
          home-manager.nixosModules.home-manager
          ./common.nix
          ./zerver.nix
          ./ts-exitnode.nix
          ./efi-live.nix
          ./a03/config.nix
          ./a03/hardware.nix
        ];
      };
    };
}
