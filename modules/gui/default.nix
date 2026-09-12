{ inputs, pkgs, ... }:

let
  hyprlandLauncher = pkgs.writeShellScriptBin "start-hyprland" ''
    # Keep graphical-session.target active for this non-UWSM session.  The
    # generated fake target is the supported manually-startable owner for it.
    ${pkgs.systemd}/bin/systemctl --user start nixos-fake-graphical-session.target
    trap '${pkgs.systemd}/bin/systemctl --user stop nixos-fake-graphical-session.target' EXIT

    ${pkgs.hyprland}/bin/start-hyprland "$@"
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
    settings = {
      auth.allow_empty_password = true;

      output = {
        name = "eDP-1";
      };

      appearance = {
        hide_logo = true;
      };
    };
  };

  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    nordzy-cursor-theme

    kitty
    firefox
    keepassxc
    steam
    zed-editor
  ];

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
    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "Nordzy-cursors";
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
}
