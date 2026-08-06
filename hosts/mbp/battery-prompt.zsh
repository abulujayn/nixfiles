prompt_mbp_battery() {
  local battery_line capacity battery_status label

  battery_line=${${(f)"$(pmset -g batt 2>/dev/null)"}[(r)*%*]}
  [[ -n $battery_line ]] || return

  if [[ $battery_line =~ '([0-9]+)%[[:space:]]*;[[:space:]]*([^;]+)' ]]; then
    capacity=$match[1]
    battery_status=${(L)match[2]}
  else
    return
  fi

  case $battery_status in
    charging|"finishing charge") label=charging ;;
    charged)                     label=full ;;
    "not charging"|"ac attached") label=idle ;;
    discharging)                 label=discharging ;;
    *)                           label=$battery_status ;;
  esac

  p10k segment -b 2 -f 0 -t $'\UF0079 '"$capacity%% [$label]"
}

typeset -ga P10K_HOST_RIGHT_PROMPT_ELEMENTS=(mbp_battery)

# Refresh the right prompt while ZLE is idle. Defining TRAPALRM prevents
# TMOUT from logging out the shell.
TMOUT=30
TRAPALRM() {
  zle reset-prompt
}
