{ inputs }:

final: prev:

{
  iloader =
    inputs.iloader.packages.${prev.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        cargoDeps = prev.rustPlatform.importCargoLock {
          lockFile = old.src + "/src-tauri/Cargo.lock";
          outputHashes = {
            "apple-codesign-0.1.0" = "sha256-ZLG/mMvXvDycDlqcd2bMjDEHtw4IiBMZVYNmYVDDdMU=";
            "isideload-0.3.17" = "sha256-6OxCzjmqENBIJkmFdlt5FiR6gG1m3Ypl75y95dxzNJk=";
          };
        };
      });
}
