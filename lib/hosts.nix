{ inputs, username }:

let
  inherit (inputs) nix-darwin nixpkgs;

  globalModule = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    programs.direnv = {
      enable = true;
      enableZshIntegration = false;
      nix-direnv.enable = true;
    };

    system.userFilesCleanup.${username} = [
      ".config/direnv/lib/hm-nix-direnv.sh"
    ];
  };

  mkHost = host: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs username;
      nixpkgsInput = nixpkgs;
    };

    modules = [
      inputs.nix-index-database.nixosModules.nix-index
      inputs.nixvim.nixosModules.nixvim
      ../modules/user-files.nix
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

  mkDarwinHost = host: nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs username;
      nixpkgsInput = nixpkgs;
    };

    modules = [
      ../modules/user-files.nix
      globalModule
      ../modules/cli/git.nix
      ../modules/cli/zsh

      {
        networking.hostName = host;
        networking.computerName = host;
        networking.localHostName = host;
      }

      ../hosts/${host}
    ];
  };
in
{
  inherit mkHost mkDarwinHost;
}
