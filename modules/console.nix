{ pkgs, ... }:

{
  # kmscon replaces the kernel's bitmap-only virtual terminal, allowing the
  # console to render the same TrueType Nerd Font used by the desktop.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  services.kmscon = {
    enable = true;
    useXkbConfig = true;

    config = {
      "font-engine" = "freetype";
      "font-name" = "JetBrainsMono Nerd Font";
      "font-size" = 16;

      palette = "custom";
      "palette-black" = "59,66,82";
      "palette-red" = "191,97,106";
      "palette-green" = "163,190,140";
      "palette-yellow" = "235,203,139";
      "palette-blue" = "129,161,193";
      "palette-magenta" = "180,142,173";
      "palette-cyan" = "136,192,208";
      "palette-light-grey" = "229,233,240";
      "palette-dark-grey" = "76,86,106";
      "palette-light-red" = "191,97,106";
      "palette-light-green" = "163,190,140";
      "palette-light-yellow" = "235,203,139";
      "palette-light-blue" = "129,161,193";
      "palette-light-magenta" = "180,142,173";
      "palette-light-cyan" = "143,188,187";
      "palette-white" = "236,239,244";
      "palette-foreground" = "216,222,233";
      "palette-background" = "46,52,64";
    };
  };
}
