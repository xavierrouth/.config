#!/bin/bash
# AeroSpace port of ~/.config/hypr/scripts/smart_focus.sh
#
# Move focus (or the focused window) up/down within the tiling tree. If we are
# already at the top/bottom edge of the workspace, cycle to the adjacent
# workspace on the same monitor instead (via cycle.sh).
#
# The original detected the edge with pixel math (jq on window/monitor geometry).
# AeroSpace exposes this directly: `focus`/`move ... --boundaries-action fail`
# exits non-zero when the window is already against the workspace boundary, so a
# simple `|| cycle.sh` reproduces the behavior.
#
#   $1 = up | down
#   $2 = "yes" to move the window, otherwise just move focus.

direction=$1
move=$2

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# up -> next workspace (+1), down -> previous workspace (-1).
if [[ "$direction" == "up" ]]; then
    sign="+1"
else
    sign="-1"
fi

if [[ "$move" == "yes" ]]; then
    aerospace move "$direction" --boundaries workspace --boundaries-action fail 2>/dev/null \
        || "$script_dir/cycle.sh" "$sign" yes
else
    aerospace focus "$direction" --boundaries workspace --boundaries-action fail 2>/dev/null \
        || "$script_dir/cycle.sh" "$sign" no
fi
