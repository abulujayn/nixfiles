{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.autoUpgrade = {
    enable = true;
    flags = [ "--no-write-lock-file" ];
  };

  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 5 --keep-since 7d --no-direnv";
    };
  };
}
