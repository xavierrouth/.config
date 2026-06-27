#!/bin/bash
# Spotify now-playing, replacing waybar/mediaplayer.py + playerctl.
if [[ "$(osascript -e 'tell application "Spotify" to player state' 2>/dev/null)" == "playing" ]]; then
    artist=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
    track=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
    sketchybar --set "$NAME" label="$artist - $track" icon="" drawing=on
else
    sketchybar --set "$NAME" drawing=off
fi
