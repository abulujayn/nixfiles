_update_battery_prompt() {
  local battery capacity battery_status colour label
  local -a batteries

  batteries=(/sys/class/power_supply/BAT*(N))
  if (( ${#batteries} == 0 )); then
    RPROMPT=
    return
  fi

  battery=$batteries[1]
  if [[ ! -r $battery/capacity || ! -r $battery/status ]]; then
    RPROMPT=
    return
  fi

  read -r capacity < $battery/capacity
  read -r battery_status < $battery/status

  case $battery_status in
    Charging)       colour=cyan;  label=charging ;;
    Full)           colour=green; label=full ;;
    "Not charging") label=idle ;;
    Discharging)    label=discharging ;;
    *)              label=${(L)battery_status} ;;
  esac

  if [[ -z $colour ]]; then
    (( capacity <= 15 )) && colour=red ||
    (( capacity <= 30 )) && colour=yellow ||
    colour=green
  fi

  RPROMPT="%F{$colour}[battery $capacity%% · $label]%f"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_battery_prompt

# Refresh the right prompt while ZLE is idle. Defining TRAPALRM prevents
# TMOUT from logging out the shell.
TMOUT=30
TRAPALRM() {
  _update_battery_prompt
  zle reset-prompt
}
