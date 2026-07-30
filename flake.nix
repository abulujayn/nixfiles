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
  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      mkHost = host: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgsInput = nixpkgs;
        };

        modules = [
          home-manager.nixosModules.home-manager

          {
            networking.hostName = host;
            system.autoUpgrade.flake = "github:abulujayn/nixfiles#${host}";
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
    };
}
