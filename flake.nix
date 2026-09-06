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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
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
      hostLib = import ./lib/hosts.nix { inherit inputs username; };
    in
    {
      devShells = import ./lib/devshells.nix { inherit nixpkgs; };

      nixosConfigurations = nixpkgs.lib.genAttrs [
        "a01"
        "a02"
        "a03"
        "thinkpad"
      ] hostLib.mkHost;

      darwinConfigurations.mbp = hostLib.mkDarwinHost "mbp";
    };
}
