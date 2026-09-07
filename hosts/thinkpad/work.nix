{ pkgs, ... }:

let
  # Citrix's current Linux download is EULA-gated and is not available from
  # the public Nix binary cache. Use the downloaded archive from the Nix store.
  citrix-workspace-local = pkgs.citrix-workspace.overrideAttrs (old: {
    version = "26.04.10.1";
    src = pkgs.requireFile {
      name = "linuxx64-gcc-8-26.04.10.1.tar.gz";
      sha256 = "sha256-jAoiytSkzagCy107sJuJd50g9oul5FS4ZIU1TFVzVrU=";
      message = "Place linuxx64-gcc-8-26.04.10.1.tar.gz in the Nix store with nix-prefetch-url.";
    };
  });
in
{
  environment.systemPackages = with pkgs; [
    citrix-workspace-local
  ];
}
