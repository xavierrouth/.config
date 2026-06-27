#!/bin/bash
# Highlights the focused workspace. $1 = the workspace id this item represents.
# Triggered by the custom `aerospace_workspace_change` event, which carries
# $FOCUSED_WORKSPACE (set by the exec-on-workspace-change hook in aerospace.toml).
sid=$1

if [[ "$sid" == "$FOCUSED_WORKSPACE" ]]; then
    sketchybar --set "$NAME" label.color=0xff1d2021 background.color=0xffd4be98 \
        background.corner_radius=4 background.height=20 background.drawing=on
else
    sketchybar --set "$NAME" label.color=0xffd4be98 background.drawing=off
fi
