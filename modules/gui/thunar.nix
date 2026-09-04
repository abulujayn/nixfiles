{ lib, pkgs, username, ... }:

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

  home-manager.users.${username} = {
    # Match the rest of the desktop while keeping Thunar's chrome understated.
    gtk = import ./gtk-theme.nix {
      inherit pkgs;
      mkValue = lib.mkDefault;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications."inode/directory" = [ "thunar.desktop" ];
    };

    xdg.configFile."xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>

      <channel name="thunar" version="1.0">
        <property name="default-view" type="string" value="ThunarDetailsView"/>
        <property name="last-view" type="string" value="ThunarDetailsView"/>
        <property name="last-location-bar" type="string" value="ThunarLocationButtons"/>
        <property name="last-side-pane" type="string" value="ThunarShortcutsPane"/>
        <property name="last-menubar-visible" type="bool" value="false"/>
        <property name="last-statusbar-visible" type="bool" value="true"/>
        <property name="last-show-hidden" type="bool" value="false"/>
        <property name="last-separator-position" type="int" value="180"/>
        <property name="last-window-width" type="int" value="1050"/>
        <property name="last-window-height" type="int" value="700"/>
        <property name="last-window-maximized" type="bool" value="false"/>
        <property name="last-details-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_75_PERCENT"/>
        <property name="last-details-view-column-order" type="string" value="THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED"/>
        <property name="last-details-view-visible-columns" type="string" value="THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED"/>
        <property name="misc-folders-first" type="bool" value="true"/>
        <property name="misc-full-path-in-title" type="bool" value="true"/>
        <property name="misc-file-size-binary" type="bool" value="true"/>
        <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_LONG"/>
        <property name="misc-thumbnail-mode" type="string" value="THUNAR_THUMBNAIL_MODE_ONLY_LOCAL"/>
        <property name="misc-open-new-window-as-tab" type="bool" value="true"/>
        <property name="misc-middle-click-in-tab" type="bool" value="true"/>
        <property name="misc-show-delete-action" type="bool" value="false"/>
        <property name="misc-exec-shell-scripts-by-default" type="bool" value="false"/>
      </channel>
    '';
  };
}
