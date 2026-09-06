{ config, lib, pkgs, username, ... }:

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
    '';

    inherit (pkgs.hyprland) version;
    meta = pkgs.hyprland.meta // {
      outputsToInstall = [ "out" ];
    };
    passthru = (pkgs.hyprland.passthru or { }) // {
      inherit (pkgs.hyprland) providedSessions;
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

  environment.systemPackages = with pkgs; [
    nordic
    nordzy-cursor-theme
    nordzy-icon-theme
  ];

  environment.sessionVariables = {
    GTK2_RC_FILES = "/etc/gtk-2.0/gtkrc";
    NOCTALIA_CONFIG_HOME = "/etc/xdg";
    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "Nordzy-cursors";
  };

  environment.etc = {
    "xdg/hypr/hyprland.lua".text = ''
      -- Keep the packaged defaults, including window and workspace bindings.
      dofile("${pkgs.hyprland}/share/hypr/hyprland.lua")

      hl.on("hyprland.start", function()
        hl.exec_cmd("${lib.getExe config.programs.noctalia.package}")
      end)
    '';

    # Noctalia v5 ships Nord as a built-in palette. Keeping this in a separate
    # file lets Noctalia merge it with settings changed through its UI.
    "xdg/noctalia/10-theme.toml".text = ''
      [theme]
      mode = "dark"
      source = "builtin"
      builtin = "Nord"
    '';
    "gtk-2.0/gtkrc".text = ''
      gtk-cursor-theme-name = "Nordzy-cursors"
      gtk-cursor-theme-size = 24
      gtk-icon-theme-name = "Nordzy-dark"
      gtk-theme-name = "Nordic"
    '';

    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
      gtk-cursor-theme-name=Nordzy-cursors
      gtk-cursor-theme-size=24
      gtk-icon-theme-name=Nordzy-dark
      gtk-theme-name=Nordic
    '';

    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
      gtk-cursor-theme-name=Nordzy-cursors
      gtk-cursor-theme-size=24
      gtk-icon-theme-name=Nordzy-dark
      gtk-interface-color-scheme=2
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
    ".config/noctalia/10-theme.toml"
    ".gtkrc-2.0"
    ".config/gtk-3.0/settings.ini"
    ".config/gtk-4.0/settings.ini"
    ".config/Kvantum/kvantum.kvconfig"
  ];
}
