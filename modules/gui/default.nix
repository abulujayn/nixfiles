{ config, inputs, lib, pkgs, username, ... }:

let
  wallpaperDirectory = pkgs.runCommand "noctalia-wallpapers" { } ''
    mkdir -p "$out"
    cp ${./bg.jpg} "$out/bg.jpg"
  '';

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
    # Keep the repository wallpaper as Noctalia's declarative default. The path
    # is copied into the Nix store, so it remains available after rebuilding.
    "xdg/noctalia/05-wallpaper.toml".text = ''
      [wallpaper]
      directory = "${wallpaperDirectory}"

      [wallpaper.default]
      path = "${wallpaperDirectory}/bg.jpg"
    '';
    "xdg/hypr/hyprland.lua".text = ''
      -- Load the packaged non-binding defaults, but start with a completely
      -- clean keymap so every active binding is declared below.
      local packaged_bind = hl.bind
      hl.bind = function() end
      dofile("${pkgs.hyprland}/share/hypr/hyprland.lua")
      hl.bind = packaged_bind

      hl.config({
        general = {
          layout = "scrolling",
        },
      })

      local mainMod = "SUPER"
      local noctalia = "noctalia msg "

      -- Core window management.
      hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle fullscreen" })
      hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle maximized" })
      hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
      hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(noctalia .. "window-switcher"))

      -- Applications and desktop shell.
      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
      hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("kitty btop"))
      hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(noctalia .. "settings-toggle"))
      hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(noctalia .. "panel-toggle control-center"))
      hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(noctalia .. "panel-toggle launcher"))
      hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(noctalia .. "session lock"))
      hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(noctalia .. "panel-toggle session"))

      -- Noctalia replaces separate screenshot, clipboard, and wallpaper tools.
      hl.bind("Print", hl.dsp.exec_cmd(noctalia .. "screenshot-annotate"))
      hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctalia .. "screenshot-fullscreen pick"))
      hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(noctalia .. "panel-toggle clipboard"))
      hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctalia .. "panel-toggle wallpaper"))

      -- Scrolling layout: move focus along the tape, reorder whole columns,
      -- move within a column, change column width, and consume/expel windows.
      for _, key in ipairs({ "left", "H" }) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.layout("focus l"), { repeating = true })
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.layout("swapcol l"), { repeating = true })
      end
      for _, key in ipairs({ "right", "L" }) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.layout("focus r"), { repeating = true })
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.layout("swapcol r"), { repeating = true })
      end
      for _, key in ipairs({ "up", "K" }) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = "up" }), { repeating = true })
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = "up" }), { repeating = true })
      end
      for _, key in ipairs({ "down", "J" }) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = "down" }), { repeating = true })
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = "down" }), { repeating = true })
      end
      hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"))
      hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -0.05"), { repeating = true })
      hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +0.05"), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.layout("fit active"))
      hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("consume_or_expel prev"))
      hl.bind(mainMod .. " + bracketright", hl.dsp.layout("consume_or_expel next"))

      -- Scratchpad and conventional numbered workspaces.
      hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))
      for workspace = 1, 10 do
        local key = workspace % 10
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
      end
      hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "e-1" }))
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

      -- Drag floating windows with the mouse and resize any window from a gap.
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Route ThinkPad volume and brightness keys through the configured
      -- Noctalia shell instead of relying on standalone helpers.
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctalia .. "volume-up"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctalia .. "volume-down"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctalia .. "volume-mute"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctalia .. "mic-mute"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctalia .. "brightness-up"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctalia .. "brightness-down"), { locked = true, repeating = true })
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
