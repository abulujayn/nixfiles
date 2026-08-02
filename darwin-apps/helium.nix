{ lib, stdenvNoCC, fetchurl, _7zz }:

stdenvNoCC.mkDerivation {
  pname = "helium";
  version = "0.15.1.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-macos/releases/download/0.15.1.1/helium_0.15.1.1_arm64-macos.dmg";
    hash = "sha256-N2W+rfqJbjv+lKnVJj7sct8vl+L2/8E3fstmmCYd7Ww=";
  };

  dontBuild = true;
  dontFixup = true;

  # The release DMG is APFS formatted, so Nixpkgs' HFS-only undmg cannot unpack it.
  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Helium.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Helium.app"
    cp -R . "$out/Applications/Helium.app"

    runHook postInstall
  '';

  meta = {
    description = "Private, fast, and user-friendly web browser for macOS";
    homepage = "https://github.com/imputnet/helium-macos";
    changelog = "https://github.com/imputnet/helium-macos/releases/tag/0.15.1.1";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
