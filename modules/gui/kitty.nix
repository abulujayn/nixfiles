{ pkgs, username, ... }:

{
  environment = {
    systemPackages = [ pkgs.kitty ];
    sessionVariables.KITTY_CONFIG_DIRECTORY = "/etc/xdg/kitty";
    etc."xdg/kitty/kitty.conf".source = pkgs.replaceVars ./config/kitty/kitty.conf {
      kittyThemes = pkgs.kitty-themes;
    };
  };

  system.userFilesCleanup.${username} = [ ".config/kitty/kitty.conf" ];
}
