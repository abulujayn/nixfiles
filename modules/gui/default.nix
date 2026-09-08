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

    # Keep graphical-session.target active for this non-UWSM session.  The
    # generated fake target is the supported manually-startable owner for it.
    ${pkgs.systemd}/bin/systemctl --user start nixos-fake-graphical-session.target
    trap '${pkgs.systemd}/bin/systemctl --user stop nixos-fake-graphical-session.target' EXIT

    ${pkgs.hyprland}/bin/start-hyprland "''${arguments[@]}"
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

  environment.systemPackages = with pkgs; [
    firefox
    keepassxc
    nordic
    nordzy-cursor-theme
    nordzy-icon-theme
    steam
    zed-editor
  ];

  nixpkgs.config.allowUnfree = true;

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
    "xdg/hypr/hyprland.lua" = {
      source = pkgs.replaceVars ./config/hypr/hyprland.lua {
        hyprland = pkgs.hyprland;
        noctalia = lib.getExe config.programs.noctalia.package;
      };
      # Hyprland canonicalizes its config path when the session starts. Keep
      # that path stable across NixOS generations so reloads see new content.
      mode = "0644";
    };

    # Noctalia v5 ships Nord as a built-in palette. Keeping this in a separate
    # file lets Noctalia merge it with settings changed through its UI.
    "xdg/noctalia/10-theme.toml".source = ./config/noctalia/10-theme.toml;
    "xdg/noctalia/15-clock.toml".source = ./config/noctalia/15-clock.toml;
    # Noctalia verifies fingerprints directly via fprintd while retaining its
    # password entry as the manual fallback.
    "xdg/noctalia/20-lockscreen-auth.toml".source = ./config/noctalia/20-lockscreen-auth.toml;
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
    ".config/noctalia/20-lockscreen-auth.toml"
    ".config/noctalia/20-no-media.toml"
    ".gtkrc-2.0"
    ".config/gtk-3.0/settings.ini"
    ".config/gtk-4.0/settings.ini"
    ".config/qt5ct/qt5ct.conf"
    ".config/Kvantum/kvantum.kvconfig"
  ];
}
