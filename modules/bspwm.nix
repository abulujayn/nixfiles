{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    displayManager.lightdm.enable = true;
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.dconf.enable = true;

  fonts.fontconfig.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    rofi
    dunst

    polkit_gnome
    xclip

    thunar

    xev
    xprop

    dejavu_fonts
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
  ];

  home-manager.users.abulujayn = {
    xdg.configFile."bspwm/bspwmrc" = {
      source = ../config/bspwm/bspwmrc;
      executable = true;
    };

    xdg.configFile."sxhkd/sxhkdrc".source = ../config/sxhkd/sxhkdrc;
  };
}
