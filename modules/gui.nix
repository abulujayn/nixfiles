{ config, lib, pkgs, username, ... }:

{
  programs.hyprland.enable = true;

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    recommendedServices.enable = true;
  };

  home-manager.users.${username} = {
    xdg.configFile."hypr/hyprland.lua".text = ''
      -- Keep the packaged defaults, including window and workspace bindings.
      dofile("${config.programs.hyprland.package}/share/hypr/hyprland.lua")

      hl.on("hyprland.start", function()
        hl.exec_cmd("${lib.getExe config.programs.noctalia.package}")
      end)
    '';

    # Noctalia v5 ships Nord as a built-in palette. Keeping this in a separate
    # file lets Noctalia merge it with settings changed through its UI.
    xdg.configFile."noctalia/10-theme.toml".text = ''
      [theme]
      mode = "dark"
      source = "builtin"
      builtin = "Nord"
    '';

    home.pointerCursor = {
      enable = true;
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
      gtk.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";

      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };

      iconTheme = {
        package = pkgs.nordzy-icon-theme;
        name = "Nordzy-dark";
      };
    };

    qt = {
      enable = true;

      platformTheme.name = "qtct";
      style.name = "kvantum";

      kvantum = {
        enable = true;
        themes = [ pkgs.nordic ];
        settings.General.theme = "Nordic";
      };
    };
  };
}
