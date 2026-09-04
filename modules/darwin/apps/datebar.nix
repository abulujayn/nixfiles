{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "datebar";
  version = "1.0.0-beta";

  src = fetchzip {
    url = "https://github.com/abulujayn/datebar/releases/download/v1.0.0-beta/datebar.app.zip";
    hash = "sha256-Hy2JPiXnejt22C+kLI79X5MNs2CCILFeXgFjH8OrJ40=";
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/datebar.app"
    cp -R "$src/datebar.app/." "$out/Applications/datebar.app"

    runHook postInstall
  '';

  meta = {
    description = "Menu bar calendar for macOS";
    homepage = "https://github.com/abulujayn/datebar";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
