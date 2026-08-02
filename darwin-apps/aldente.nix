{ lib, stdenvNoCC, fetchurl, _7zz }:

stdenvNoCC.mkDerivation {
  pname = "aldente";
  version = "1.38";

  src = fetchurl {
    url = "https://github.com/AppHouseKitchen/AlDente-Battery_Care_and_Monitoring/releases/download/1.38/AlDente.dmg";
    hash = "sha256-80XORI/apvKu12q7TkkeZBeHL0tbyywal/hgKNWY5L8=";
  };

  dontBuild = true;
  dontFixup = true;

  # AlDente.dmg is APFS formatted, so Nixpkgs' HFS-only undmg cannot unpack it.
  nativeBuildInputs = [ _7zz ];

  sourceRoot = "AlDente.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/AlDente.app"
    cp -R . "$out/Applications/AlDente.app"

    runHook postInstall
  '';

  meta = {
    description = "macOS tool to limit maximum charging percentage";
    homepage = "https://apphousekitchen.com";
    changelog = "https://github.com/AppHouseKitchen/AlDente-Battery_Care_and_Monitoring/releases/tag/1.38";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
