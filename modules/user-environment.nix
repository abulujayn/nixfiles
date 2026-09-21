{
  pkgs,
  settings,
  username,
  ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    linger = true;
    uid = settings.user.uid;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.${username}.home.packages = with pkgs; [
    fastfetch
    distrobox
  ];

  environment.systemPackages = with pkgs; [
    codex
    wget
    curl
    gawk
    ripgrep
    gnugrep
    jq
    unzip
    less
    fd
    tree

    python314
    python314Packages.pip

    btop
    tmux
    kitty.terminfo
  ];
}
