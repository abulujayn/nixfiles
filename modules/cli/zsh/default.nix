{ inputs, lib, pkgs, username, ... }:

{
  programs.zsh = {
    enable = true;
    # Oh My Zsh initializes completion after the completion generator is loaded.
    enableBashCompletion = false;
    enableGlobalCompInit = false;
    histFile = "$HOME/.config/zsh/histfile";
    promptInit = "";
    shellInit = ''
      export ZDOTDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
      export GENCOMPL_FPATH="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion-generator"
      export GENCOMPL_PY="${pkgs.python3}/bin/python3"
      ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
      ZSH_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
    '';

    interactiveShellInit = lib.mkMerge [
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        mkdir -p "$ZSH_CACHE_DIR" "$(dirname "$HISTFILE")"

        typeset -U path cdpath fpath manpath
        HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"
      '')
      (lib.mkOrder 550 ''
        source ${
          inputs.zsh-completion-generator
          + "/zsh-completion-generator.plugin.zsh"
        }
      '')
      (lib.mkOrder 560 "source ${./init.zsh}")
      (lib.mkOrder 600 ''
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history)
      '')
      (lib.mkOrder 700 ''
        zstyle ':omz:plugins:ssh-agent' quiet yes
        zstyle ':omz:plugins:ssh-agent' lazy yes

        ZSH_THEME=""
        plugins=(
          command-not-found
          git
          brew
          ssh
          ssh-agent
          npm
          extract
          dotenv
          gh
          magic-enter
          safe-paste
        )
        source "$ZSH/oh-my-zsh.sh"
      '')
      # Oh My Zsh overwrites matcher-list while loading its defaults.
      (lib.mkOrder 850 "source ${./init.zsh}")
      (lib.mkOrder 900 ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '')
      (lib.mkOrder 930 ''
        HISTSIZE=1000
        SAVEHIST=5000
        setopt \
          HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY \
          NO_APPEND_HISTORY NO_EXTENDED_HISTORY NO_HIST_EXPIRE_DUPS_FIRST \
          NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS
      '')
      (lib.mkOrder 970 ''
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"
      '')
      (lib.mkOrder 1000 ''
        source ${./p10k-base.zsh}
        source ${./p10k.zsh}
      '')
      (lib.mkOrder 1300 ''
        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        bindkey "^[[A" history-substring-search-up
        bindkey "^[[B" history-substring-search-down
      '')
      (lib.mkOrder 1400 ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
      '')
    ];
  };

  users.users.${username}.shell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    oh-my-zsh
    zsh-autosuggestions
    zsh-fast-syntax-highlighting
    zsh-history-substring-search
    zsh-powerlevel10k
  ];

  system.userFilesCleanup.${username} = [
    ".zshenv"
    ".config/zsh/.zprofile"
    ".config/zsh/.zshenv"
    ".config/zsh/.zshrc"
    ".config/zsh/plugins/powerlevel10k"
  ];
}
