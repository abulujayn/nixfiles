{ inputs, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.abulujayn.shell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.abulujayn =
    { config, pkgs, ... }:
    {
      imports = [
        ../lib/zsh-styles.nix
      ];

      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        initContent = "source ${../config/zsh/prompt.zsh}";
        autosuggestion.enable = true;
        historySubstringSearch.enable = true;

        sessionVariables = {
          GENCOMPL_FPATH = "${config.xdg.cacheHome}/zsh/completion-generator";
          GENCOMPL_PY = "${pkgs.python3}/bin/python3";
        };

        oh-my-zsh = {
          enable = true;
          theme = "";
          plugins = [
            "command-not-found"
            "git"
            "brew"
            "ssh"
            "ssh-agent"
            "npm"
            "extract"
            "dotenv"
            "gh"
            "magic-enter"
            "safe-paste"
          ];
        };

        extraPlugins = [
          {
            file =
              inputs.zsh-completion-generator
              + "/zsh-completion-generator.plugin.zsh";
            phase = "beforeCompletion";
          }
          {
            file =
              pkgs.zsh-fast-syntax-highlighting
              + "/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
            phase = "last";
          }
        ];

        zstyles = [
          "':completion:*' completer _expand _complete _ignored _correct"
          "':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'"
          "':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'"
          "':completion:*' menu select=1"
          "':completion:*' original true"
          "':completion:*' select-prompt '%SScrolling active: current selection at %p%s'"
          "':completion:*' squeeze-slashes true"

          "':omz:plugins:ssh-agent' quiet yes"
          "':omz:plugins:ssh-agent' lazy yes"
        ];

        history = {
          path = "${config.xdg.configHome}/zsh/histfile";
          size = 1000;
          save = 5000;
        };
      };
    };
}
