{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.mbpvm = nixpkgs.lib.nixosSystem {
      modules = [
        home-manager.nixosModules.home-manager
        ./common.nix
        ./zerver.nix
        ./mbpvm/config.nix
        ./mbpvm/hardware.nix
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
  };
}
