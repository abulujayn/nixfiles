{ config, inputs, lib, pkgs, username, ... }:

let
  hyprlandLauncher = pkgs.writeShellScriptBin "start-hyprland" ''
    arguments=()
    found_separator=

    for argument in "$@"; do
      if [[ -z "$found_separator" && "$argument" == -- ]]; then
        arguments+=( "$argument" --config /etc/xdg/hypr/hyprland.lua )
        found_separator=1
      else
        arguments+=( "$argument" )
      fi
    done

    if [[ -z "$found_separator" ]]; then
      arguments+=( -- --config /etc/xdg/hypr/hyprland.lua )
    fi

    exec ${pkgs.hyprland}/bin/start-hyprland "''${arguments[@]}"
  '';

  hyprland = pkgs.symlinkJoin {
    name = "${pkgs.hyprland.name}-system-config";
    paths = [
      pkgs.hyprland
      pkgs.hyprland.man
    ];

    postBuild = ''
      rm "$out/bin/start-hyprland"
      ln -s ${hyprlandLauncher}/bin/start-hyprland "$out/bin/start-hyprland"

      rm "$out/share/wayland-sessions/hyprland.desktop"
      substitute ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop \
        "$out/share/wayland-sessions/hyprland.desktop" \
        --replace-fail ${pkgs.hyprland}/bin/start-hyprland "$out/bin/start-hyprland"

      # This configuration does not enable UWSM. Keep the package's normal
      # Hyprland session visible without advertising the unmanaged extra entry.
      rm -f "$out/share/wayland-sessions/hyprland-uwsm.desktop"
    '';

    inherit (pkgs.hyprland) version;
    meta = pkgs.hyprland.meta // {
      outputsToInstall = [ "out" ];
    };
    passthru = (pkgs.hyprland.passthru or { }) // {
      providedSessions = [ "hyprland" ];
      override = _: hyprland;
    };
  };

  # Keep the cached portal build tied to the unwrapped compositor package.
  hyprlandPortal = pkgs.xdg-desktop-portal-hyprland // {
    override = _: hyprlandPortal;
  };
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
    ./firefox.nix
    ./kitty.nix
    ./thunar.nix
  ];

  programs.hyprland = {
    enable = true;
    package = hyprland;
    portalPackage = hyprlandPortal;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    recommendedServices.enable = true;
  };

  programs.noctalia-greeter = {
    enable = true;
    settings.auth.allow_empty_password = true;
  };

  services.fprintd.enable = true;

  # Let Hyprland handle a short power-button press so it can open Noctalia's
  # session menu. logind retains its default long-press emergency handling.
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Noctalia submits the password to the first PAM prompt. Try pam_unix first
  # so a valid password completes authentication without waiting for a scan;
  # an empty submission falls through to pam_fprintd instead.
  security.pam.services.login.rules.auth.fprintd.order =
    config.security.pam.services.login.rules.auth.unix.order + 10;

  environment.systemPackages = with pkgs; [
    nordic
    nordzy-cursor-theme
    nordzy-icon-theme
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
    "xdg/noctalia/05-wallpaper.toml".source = ./config/noctalia/05-wallpaper.toml;
    "xdg/hypr/hyprland.lua".source = pkgs.replaceVars ./config/hypr/hyprland.lua {
      hyprland = pkgs.hyprland;
      noctalia = lib.getExe config.programs.noctalia.package;
    };

    # Noctalia v5 ships Nord as a built-in palette. Keeping this in a separate
    # file lets Noctalia merge it with settings changed through its UI.
    "xdg/noctalia/10-theme.toml".source = ./config/noctalia/10-theme.toml;
    "xdg/noctalia/15-clock.toml".source = ./config/noctalia/15-clock.toml;
    # Keep Noctalia focused on desktop and system controls rather than media.
    # This wins over the built-in defaults while remaining independent of the
    # theme configuration above.
    "xdg/noctalia/20-no-media.toml".source = ./config/noctalia/20-no-media.toml;
    "gtk-2.0/gtkrc".source = ./config/gtk-2.0/gtkrc;
    "gtk-3.0/settings.ini".source = ./config/gtk-3.0/settings.ini;
    "gtk-4.0/settings.ini".source = ./config/gtk-4.0/settings.ini;

    # qt5ct is the configured Qt platform theme, so make its application
    # font explicit instead of relying only on Fontconfig's generic mapping.
    "xdg/qt5ct/qt5ct.conf".source = ./config/qt5ct/qt5ct.conf;
    "xdg/Kvantum/kvantum.kvconfig".source = ./config/Kvantum/kvantum.kvconfig;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  system.userFilesCleanup.${username} = [
    ".icons/default/index.theme"
    ".config/hypr/hyprland.lua"
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
