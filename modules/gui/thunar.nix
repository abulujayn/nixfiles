{ pkgs, ... }:

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
}
