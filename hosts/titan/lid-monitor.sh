#!/bin/sh

INTERNAL_DISPLAY="DP-1"
LOG_FILE="${1:-}"

log() {
    [ -n "$LOG_FILE" ] || return 0
    printf '%s: %s\n' "$(date)" "$*" >>"$LOG_FILE"
}

log_cmd() {
    if [ -n "$LOG_FILE" ]; then
        "$@" >>"$LOG_FILE" 2>&1
    else
        "$@"
    fi
}

external_display_active() {
    xrandr --query | awk -v internal="$INTERNAL_DISPLAY" '
        $1 != internal &&
        $2 == "connected" &&
        $3 ~ /^[0-9]+x[0-9]+\+/ {
            found = 1
        }
        END {
            exit !found
        }
    '
}

log "lid monitor started"

acpi_listen | while IFS= read -r event; do
    log "$event"

    case "$event" in
        button/lid*)
            if grep -q closed /proc/acpi/button/lid/*/state; then
                if external_display_active; then
                    log "disabling internal display"
                    log_cmd xrandr --output "$INTERNAL_DISPLAY" --off
                else
                    log "no external display; turning display off with DPMS"
                    log_cmd xset dpms force off
                fi
            else
                log "enabling internal display"

                log_cmd xset dpms force on
                log_cmd xrandr --output "$INTERNAL_DISPLAY" --auto
            fi
            ;;
    esac
done
