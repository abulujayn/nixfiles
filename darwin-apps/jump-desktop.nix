{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  xar,
  gzip,
  cpio,
}:

stdenvNoCC.mkDerivation {
  pname = "jump-desktop-connect";
  version = "7.1.52";

  src = fetchurl {
    url = "https://mirror.jumpdesktop.com/downloads/connect/JumpDesktopConnect.dmg";
    hash = "sha256-Y1Rr52YKVULgQf8X8g5lCRW6urLjaywp+tFhF5mPu4Q=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [
    undmg
    xar
    gzip
    cpio
  ];

  installPhase = ''
    runHook preInstall

    unpackDir="$TMPDIR/jump-desktop-connect"
    mkdir -p "$unpackDir"
    cd "$unpackDir"

    undmg "$src"
    xar -xf .jdc.sparkle_guided.pkg Jump_Desktop_Connect.pkg/Payload

    mkdir payload
    cd payload
    gzip -dc ../Jump_Desktop_Connect.pkg/Payload | cpio -idm

    mkdir -p "$out/Applications"
    cp -R "Applications/Jump Desktop Connect.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Remote access host for Jump Desktop";
    homepage = "https://jumpdesktop.com/connect/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
