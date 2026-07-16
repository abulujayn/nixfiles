{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "3.0.2";
  platformMap = {
    aarch64-linux = {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz-arm64.efi";
      hash = "sha256-bEr7YV2+EiOZYPImMBLTxK7f/KP/DmAPrG8yKjv8Nk0=";
    };
    x86_64-linux = {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.efi";
      hash = "sha256-4PbBxZPh2grQg/nXoOOjWAhR9gJqNgR53oriAUrv0i8=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netboot.xyz-efi";
  inherit version;

  src = fetchurl {
    inherit
      (platformMap.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
      )
      url
      hash
      ;
  };

  dontUnpack = true;

  postInstall = ''
    cp $src $out
  '';

  meta = {
    homepage = "https://netboot.xyz/";
    description = "Tool to boot OS installers and utilities over the network, to be run from a bootloader";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames platformMap;
    maintainers = with lib.maintainers; [ pinpox ];
  };
})
