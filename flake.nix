{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
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

    iloader = {
      url = "github:nab138/iloader/v2.3.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, ... }:
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
    };
}
