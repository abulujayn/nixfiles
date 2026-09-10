{ inputs, username }:

let
  inherit (inputs) nixpkgs;

  globalModule = {
    nixpkgs.overlays = [
      (final: prev: {
        libratbag = prev.callPackage ../packages/libratbag.nix {
          libratbag = prev.libratbag;
        };
      })
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    programs.direnv = {
      enable = true;
      enableZshIntegration = false;
      nix-direnv.enable = true;
    };

  };

  mkHost = host: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs username;
      nixpkgsInput = nixpkgs;
    };

    modules = [
      inputs.nix-index-database.nixosModules.nix-index
      ../modules/nix-index.nix
      globalModule
      ../modules/common.nix
      ../modules/cli

      {
        networking.hostName = host;
        system.autoUpgrade.flake = "github:abulujayn/nixfiles#${host}";
      }

      ../hosts/${host}
    ];
  };
in
{
  inherit mkHost;
}
