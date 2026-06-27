#!/bin/bash
# CPU usage %, replacing waybar cpu module.
usage=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s/'"$(sysctl -n hw.ncpu)"'}')
sketchybar --set "$NAME" label="${usage}%"
