# Match the default NixOS Bash prompt.
if (( EUID == 0 )); then
  PROMPT=$'\n%B%F{red}[%n@%m:%~]#%f%b '
else
  PROMPT=$'\n%B%F{green}[%n@%m:%~]$%f%b '
fi
