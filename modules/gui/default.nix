{ config, inputs, lib, pkgs, username, ... }:

let
  wallpaperDirectory = pkgs.runCommand "noctalia-wallpapers" { } ''
    mkdir -p "$out"
    cp ${./bg.jpg} "$out/bg.jpg"
  '';
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
    ./firefox.nix
    ./kitty.nix
    ./thunar.nix
  ];

  programs.niri.enable = true;

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    recommendedServices.enable = true;
  };

  programs.noctalia-greeter.enable = true;

  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    fuzzel
    nordic
    nordzy-cursor-theme
    nordzy-icon-theme
    playerctl
    swaylock
  ];

  # Use one patched family throughout the desktop.  Fontconfig also provides
  # this mapping to applications which do not have a toolkit-specific setting.
  fonts = {
    packages = [ pkgs.nerd-fonts.jetbrains-mono ];
    fontconfig.defaultFonts = {
      serif = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
    };
  };

  environment.sessionVariables = {
    # Thunar is a GTK application.  Set the theme in its launch environment so
    # it keeps the Nord dark appearance independently of an Xfce settings daemon.
    GTK_THEME = "Nordic";
    GTK2_RC_FILES = "/etc/gtk-2.0/gtkrc";
    NOCTALIA_CONFIG_HOME = "/etc/xdg";
    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "Nordzy-cursors";
  };

  environment.etc = {
    # Keep the repository wallpaper as Noctalia's declarative default. The path
    # is copied into the Nix store, so it remains available after rebuilding.
    "xdg/noctalia/05-wallpaper.toml".text = ''
      [wallpaper]
      directory = "${wallpaperDirectory}"

      [wallpaper.default]
      path = "${wallpaperDirectory}/bg.jpg"
    '';
    # Start from the exact config shipped by the pinned Niri package. Noctalia
    # replaces Waybar as the desktop shell, but all key bindings stay upstream.
    "niri/config.kdl".text = lib.replaceString
      ''spawn-at-startup "waybar"''
      ''spawn-at-startup "${lib.getExe config.programs.noctalia.package}"''
      (builtins.readFile "${pkgs.niri.doc}/share/doc/niri/default-config.kdl");

    # Noctalia v5 ships Nord as a built-in palette. Keeping this in a separate
    # file lets Noctalia merge it with settings changed through its UI.
    "xdg/noctalia/10-theme.toml".text = ''
      [theme]
      mode = "dark"
      source = "builtin"
      builtin = "Nord"
    '';
    "xdg/noctalia/15-clock.toml".text = ''
      [shell]
      time_format = "{:%H:%M}"
    '';
    # Keep Noctalia focused on desktop and system controls rather than media.
    # This wins over the built-in defaults while remaining independent of the
    # theme configuration above.
    "xdg/noctalia/20-no-media.toml".text = ''
      [desktop_widgets]
      enabled = false

      [lockscreen_widgets]
      enabled = false

      # The login box is part of the lock screen itself, rather than a regular
      # desktop widget.  Its media row defaults to showing “Nothing Playing”.
      [lockscreen_widgets.widget."lockscreen-login-box@eDP-1"]
      type = "login_box"
      output = "eDP-1"

      [lockscreen_widgets.widget."lockscreen-login-box@eDP-1".settings]
      show_media = false

      [widget.media]
      enabled = false

      [control_center]
      hidden_tabs = ["media"]

      [osd.kinds]
      media = false
    '';
    "gtk-2.0/gtkrc".text = ''
      gtk-cursor-theme-name = "Nordzy-cursors"
      gtk-cursor-theme-size = 24
      gtk-font-name = "JetBrainsMono Nerd Font 11"
      gtk-monospace-font-name = "JetBrainsMono Nerd Font Mono 11"
      gtk-icon-theme-name = "Nordzy-dark"
      gtk-theme-name = "Nordic"
    '';

    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
      gtk-cursor-theme-name=Nordzy-cursors
      gtk-cursor-theme-size=24
      gtk-font-name=JetBrainsMono Nerd Font 11
      gtk-monospace-font-name=JetBrainsMono Nerd Font Mono 11
      gtk-icon-theme-name=Nordzy-dark
      gtk-theme-name=Nordic
    '';

    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
      gtk-cursor-theme-name=Nordzy-cursors
      gtk-cursor-theme-size=24
      gtk-font-name=JetBrainsMono Nerd Font 11
      gtk-monospace-font-name=JetBrainsMono Nerd Font Mono 11
      gtk-icon-theme-name=Nordzy-dark
      gtk-interface-color-scheme=2
    '';

    # qt5ct is the configured Qt platform theme, so make its application
    # font explicit instead of relying only on Fontconfig's generic mapping.
    "xdg/qt5ct/qt5ct.conf".text = ''
      [Fonts]
      general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
      fixed="JetBrainsMono Nerd Font Mono,11,-1,5,50,0,0,0,0,0"
    '';

    "xdg/Kvantum/kvantum.kvconfig".text = ''
      [Applications]

      [General]
      theme=Nordic
    '';
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  system.userFilesCleanup.${username} = [
    ".icons/default/index.theme"
    ".config/hypr/hyprland.lua"
    ".config/niri/config.kdl"
    ".config/noctalia/05-wallpaper.toml"
    ".config/noctalia/10-theme.toml"
    ".config/noctalia/15-clock.toml"
    ".config/noctalia/20-no-media.toml"
    ".gtkrc-2.0"
    ".config/gtk-3.0/settings.ini"
    ".config/gtk-4.0/settings.ini"
    ".config/qt5ct/qt5ct.conf"
    ".config/Kvantum/kvantum.kvconfig"
  ];
}
