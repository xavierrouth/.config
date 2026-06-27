#!/bin/bash
# Wifi SSID, replacing waybar network module.
ssid=$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2; exit}')
if [[ -n "$ssid" ]]; then
    sketchybar --set "$NAME" icon="" label="$ssid"
else
    sketchybar --set "$NAME" icon="" label="Disconnected"
fi
