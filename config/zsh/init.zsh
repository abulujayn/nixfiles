# Match the default NixOS Bash prompt.
if (( EUID == 0 )); then
  PROMPT=$'\n%B%F{red}[%n@%m:%~]#%f%b '
else
  PROMPT=$'\n%B%F{green}[%n@%m:%~]$%f%b '
fi

zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' squeeze-slashes true
autoload -Uz compinit
compinit

zstyle ':omz:plugins:ssh-agent' quiet yes
zstyle ':omz:plugins:ssh-agent' lazy yes
