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

  programs.noctalia-greeter.enable = true;

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
    "xdg/hypr/hyprland.lua".text = ''
      -- Keep the packaged defaults, but replace their conflicting shortcuts with
      -- the CachyOS layout below.  Hyprland accepts more than one action for a
      -- key, so filter the packaged bindings before loading them rather than
      -- registering a second action for the same chord.
      local packaged_bind = hl.bind
      local replaced_binds = {
        ["SUPER + Q"] = true,
        ["SUPER + C"] = true,
        ["SUPER + E"] = true,
        ["SUPER + M"] = true,
        ["SUPER + V"] = true,
        ["SUPER + R"] = true,
        ["SUPER + mouse_down"] = true,
        ["SUPER + mouse_up"] = true,
        ["XF86AudioRaiseVolume"] = true,
        ["XF86AudioLowerVolume"] = true,
        ["XF86AudioMute"] = true,
        ["XF86AudioMicMute"] = true,
        ["XF86MonBrightnessUp"] = true,
        ["XF86MonBrightnessDown"] = true,
        ["XF86AudioNext"] = true,
        ["XF86AudioPause"] = true,
        ["XF86AudioPlay"] = true,
        ["XF86AudioPrev"] = true,
      }

      for key = 0, 9 do
        replaced_binds["SUPER + " .. key] = true
        replaced_binds["SUPER + SHIFT + " .. key] = true
      end

      hl.bind = function(keys, action, options)
        if not replaced_binds[keys] then
          return packaged_bind(keys, action, options)
        end
      end
      dofile("${pkgs.hyprland}/share/hypr/hyprland.lua")
      hl.bind = packaged_bind

      local mainMod = "SUPER"
      local noctalia = "noctalia msg "

      -- Window management (CachyOS layout).
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
      hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
      hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(noctalia .. "window-switcher"))

      -- Launch only applications and shell surfaces already configured here.
      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
      hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
      hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("kitty btop"))
      hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(noctalia .. "settings-toggle"))
      hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(noctalia .. "panel-toggle control-center"))
      hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(noctalia .. "panel-toggle launcher"))
      hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(noctalia .. "session lock"))
      hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(noctalia .. "panel-toggle session"))

      -- Noctalia replaces separate screenshot, clipboard, and wallpaper tools.
      hl.bind("Print", hl.dsp.exec_cmd(noctalia .. "screenshot-annotate"))
      hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctalia .. "screenshot-fullscreen pick"))
      hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctalia .. "panel-toggle clipboard"))
      hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctalia .. "panel-toggle wallpaper"))

      -- Workspace navigation follows CachyOS's modifier scheme.  This machine
      -- has no fixed multi-monitor layout, so monitor-specific number bindings
      -- are deliberately omitted.
      for workspace = 1, 10 do
        local key = workspace % 10
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.focus({ workspace = workspace }))
        hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
      end
      hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "e-1" }))
      hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + CTRL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

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
