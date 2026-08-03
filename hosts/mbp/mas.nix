{ inputs, pkgs, ... }:

{
  programs.mas = {
    enable = true;

    packages = [
      "Amphetamine" = 937984704;
      "Windows App" = 1295203466;
      "uBlock" = 6745342698;
      "Xcode" = 497799835;
    ];
  };
}
