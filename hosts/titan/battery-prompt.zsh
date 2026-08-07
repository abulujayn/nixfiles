prompt_titan_battery() {
  local battery capacity battery_status label
  local -a batteries

  batteries=(/sys/class/power_supply/BAT*(N))
  (( ${#batteries} )) || return

  battery=$batteries[1]
  [[ -r $battery/capacity && -r $battery/status ]] || return

  read -r capacity < $battery/capacity
  read -r battery_status < $battery/status

  [[ $capacity == <-> ]] || return
  (( capacity < 30 || capacity > 80 )) || return

  case $battery_status in
    Charging)       label=charging ;;
    Full)           label=full ;;
    "Not charging") label=idle ;;
    Discharging)    label=discharging ;;
    *)              label=${(L)battery_status} ;;
  esac

  p10k segment -b 2 -f 0 -t $'\UF0079 '"$capacity%% [$label]"
}

typeset -ga P10K_HOST_RIGHT_PROMPT_ELEMENTS=(titan_battery)

# Refresh the right prompt while ZLE is idle. Defining TRAPALRM prevents
# TMOUT from logging out the shell.
TMOUT=30
TRAPALRM() {
  zle reset-prompt
}
