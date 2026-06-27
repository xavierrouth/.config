#!/bin/bash
# AeroSpace port of ~/.config/hypr/scripts/cycle.sh
#
# Cycle to the adjacent workspace within the current monitor's group, wrapping
# around: 1-5 on the primary monitor, 6-10 on the secondary monitor.
#   $1 = shift amount (+1 to go up/next, -1 to go down/prev)
#   $2 = "yes" to carry the focused window along; otherwise just switch.

shift_amount=$1
move=$2

current=$(aerospace list-workspaces --focused)
next=$((current + shift_amount))

# Wrap within the monitor's workspace group (matches the Hyprland intent: the
# two groups 1-5 and 6-10 each cycle among themselves).
if (( current >= 6 && current <= 10 )); then
    (( next == 11 )) && next=6
    (( next == 5 ))  && next=10
elif (( current >= 1 && current <= 5 )); then
    (( next == 6 )) && next=1
    (( next == 0 )) && next=5
fi

if [[ "$move" == "yes" ]]; then
    aerospace move-node-to-workspace "$next"
    aerospace workspace "$next"
else
    aerospace workspace "$next"
fi
