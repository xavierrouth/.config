#!/bin/bash
# Matches Waybar clock: "Saturday, June 27, 2026 | 11:30 AM"
sketchybar --set "$NAME" label="$(date '+%A, %B %d, %Y | %I:%M %p')"
