#!/bin/bash
pct=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
charging=$(pmset -g batt | grep -c 'AC Power')
[[ -z "$pct" ]] && exit 0

if [[ "$charging" -eq 1 ]]; then icon=""
else
    case "$pct" in
        100|[8-9][0-9]) icon="" ;;
        [6-7][0-9])     icon="" ;;
        [4-5][0-9])     icon="" ;;
        [2-3][0-9])     icon="" ;;
        *)              icon="" ;;
    esac
fi
sketchybar --set "$NAME" icon="$icon" label="${pct}%"
