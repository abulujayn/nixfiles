{ pkgs, username, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };

  # File previews and transparent access to trash, network shares, and phones.
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  xdg.mime.defaultApplications."inode/directory" = [ "thunar.desktop" ];

  # Xfconf treats /etc/xdg as system defaults while keeping runtime changes in
  # the user's writable Xfconf state.
  environment.etc."xdg/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".source =
    ./config/thunar/thunar.xml;

  system.userFilesCleanup.${username} = [
    ".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
  ];
}
