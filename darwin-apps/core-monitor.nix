{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "core-monitor";
  version = "16";

  src = fetchzip {
    url = "https://github.com/offyotto/Core-Monitor/releases/download/v16/Core-Monitor.app.zip";
    hash = "sha256-7ZR7VS1qd+kJGFNvkUTU4dGVrAjraB5ex77BAt9dz9Y=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Core Monitor.app"
    cp -R "$src/." "$out/Applications/Core Monitor.app"

    runHook postInstall
  '';

  meta = {
    description = "Menu bar CPU core usage monitor for macOS";
    homepage = "https://github.com/offyotto/Core-Monitor";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
