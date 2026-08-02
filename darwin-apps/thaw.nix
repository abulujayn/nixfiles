{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "thaw";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/thaw-app/Thaw/releases/download/1.2.0/Thaw_1.2.0.zip";
    hash = "sha256-UZCtVWYof6ZThDWmwDXV75jzEighMOnxsaVt7Bl9JNc=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Thaw.app"
    cp -R "$src/." "$out/Applications/Thaw.app"

    runHook postInstall
  '';

  meta = {
    description = "Menu bar manager for macOS";
    homepage = "https://github.com/thaw-app/Thaw";
    changelog = "https://github.com/thaw-app/Thaw/releases/tag/1.2.0";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
