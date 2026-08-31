{ pkgs, username, ... }:

{
  # Niri's NixOS module also installs its session, portals, and keyring support.
  programs.niri.enable = true;

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };

  home-manager.users.${username} = {
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
