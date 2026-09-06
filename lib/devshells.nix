{ nixpkgs }:

nixpkgs.lib.genAttrs [
  "aarch64-darwin"
  "aarch64-linux"
  "x86_64-linux"
] (system: {
  default = nixpkgs.legacyPackages.${system}.mkShell {
    packages = with nixpkgs.legacyPackages.${system}; [
      nil
      nixd
    ];
  };
})
