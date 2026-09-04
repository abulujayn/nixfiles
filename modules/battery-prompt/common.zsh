prompt_battery_segment() {
  local capacity=$1 label=$2

  [[ $capacity == <-> ]] || return
  (( capacity < 30 || capacity > 80 )) || return

  p10k segment -b 2 -f 0 -t $'\UF0079 '"$capacity%% [$label]"
}

# Refresh the right prompt while ZLE is idle. Defining TRAPALRM prevents
# TMOUT from logging out the shell.
TMOUT=30
TRAPALRM() {
  zle reset-prompt
}
