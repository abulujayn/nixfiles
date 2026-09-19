{ inputs, pkgs, username, ... }:

{
  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.${username} =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ../lib/zsh-options.nix
      ];

      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        initContent = lib.mkMerge [
          (lib.mkOrder 500 ''
            if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
          '')
          (lib.mkOrder 1000 ''
            source ${../config/zsh/init.zsh}
            source ${../config/zsh/p10k.zsh}
          '')
        ];
        autosuggestion.enable = true;
        historySubstringSearch.enable = true;

        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];

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

        history = {
          path = "${config.xdg.configHome}/zsh/histfile";
          size = 1000;
          save = 5000;
        };
      };
    };
}
