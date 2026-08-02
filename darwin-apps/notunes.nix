{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "notunes";
  version = "3.5";

  src = fetchzip {
    url = "https://github.com/tombonez/noTunes/releases/download/v3.5/noTunes-3.5.zip";
    hash = "sha256-cFT44TLMkyigHt2rYDtAYLJil+WTHOf9KogwIcOGHHU=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/noTunes.app"
    cp -R "$src/." "$out/Applications/noTunes.app"

    runHook postInstall
  '';

  meta = {
    description = "Prevent Apple Music from launching automatically on macOS";
    homepage = "https://github.com/tombonez/noTunes";
    changelog = "https://github.com/tombonez/noTunes/releases/tag/v3.5";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
