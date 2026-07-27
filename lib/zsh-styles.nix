{ config, lib, ... }:

let
  extraPlugins = config.programs.zsh.extraPlugins;
  zstyles = config.programs.zsh.zstyles;

  renderStyle = style: "zstyle ${style}";

  phaseOrders = {
    beforeCompletion = 550;
    last = 1400;
  };

  extraPluginType = lib.types.submodule {
    options = {
      file = lib.mkOption {
        type = lib.types.path;
        example = lib.literalExpression ''
          pkgs.example-zsh-plugin + "/share/zsh/example.plugin.zsh"
        '';
        description = "The Zsh plugin file to source.";
      };

      phase = lib.mkOption {
        type = lib.types.enum [
          "beforeCompletion"
          "last"
        ];
        description = "When the Zsh plugin should be sourced.";
      };
    };
  };

  renderPlugin =
    { file, phase }:
    lib.mkOrder phaseOrders.${phase} "source ${lib.escapeShellArg (toString file)}";
in
{
  options.programs.zsh = {
    extraPlugins = lib.mkOption {
      type = lib.types.listOf extraPluginType;
      default = [ ];
      description = "Declarative Zsh plugins with explicit loading phases.";
    };

    zstyles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "':completion:*' menu select=1" ];
      description = "Declarative Zsh styles.";
    };
  };

  config.programs.zsh.initContent = lib.mkIf config.programs.zsh.enable (
    lib.mkMerge (
      lib.optional (zstyles != [ ]) (
        lib.mkOrder 550 (lib.concatMapStringsSep "\n" renderStyle zstyles)
      )
      ++ map renderPlugin extraPlugins
    )
  );
}
