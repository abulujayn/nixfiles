{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  xar,
  gzip,
  cpio,
}:

stdenvNoCC.mkDerivation {
  pname = "amphetamine-power-protect";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/x74353/Amphetamine-Power-Protect/raw/main/DMG/Power%20Protect%20for%20Amphetamine.dmg";
    hash = "sha256-9WJ5BtYfFBxzdDyjfEWI/Hn88qFj71+PVi+34Ohesso=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [
    _7zz
    xar
    gzip
    cpio
  ];

  installPhase = ''
    runHook preInstall

    workDir="$TMPDIR/amphetamine-power-protect"
    mkdir -p "$workDir/dmg" "$workDir/pkg" "$workDir/payload"

    7zz x -y -o"$workDir/dmg" "$src" "Install Power Protect.pkg"

    cd "$workDir/pkg"
    xar -xf "$workDir/dmg/Install Power Protect.pkg" \
      Power_Protect_for_Amphetamine.pkg/Payload

    cd "$workDir/payload"
    gzip -dc "$workDir/pkg/Power_Protect_for_Amphetamine.pkg/Payload" | cpio -idm

    install -Dm444 \
      "Library/Application Scripts/com.if.Amphetamine/powerProtect.scpt" \
      "$out/Library/Application Scripts/com.if.Amphetamine/powerProtect.scpt"
    install -Dm440 \
      private/etc/sudoers.d/amphetamine_PowerProtect \
      "$out/etc/sudoers.d/amphetamine_powerProtect"

    runHook postInstall
  '';

  meta = {
    description = "Power Protect support files for Amphetamine on Apple silicon Macs";
    homepage = "https://github.com/x74353/Amphetamine-Power-Protect";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
