#!/bin/bash
# AeroSpace port of ~/.config/hypr/scripts/obsidian_focus.sh
#
# Jump to a pinned app (Obsidian / Spotify), launching it if needed, and remember
# the workspace we came from so `back` can return to it. Obsidian and Spotify are
# pinned to workspaces 10 and 9 via [[on-window-detected]] rules in aerospace.toml.
#
#   $1 = obsidian | spotify | back
set -euo pipefail

OBSIDIAN_WS=10
SPOTIFY_WS=9
STATE_FILE="$HOME/.config/aerospace/last_workspace"

cur_ws() { aerospace list-workspaces --focused; }

save_last() {
  local ws="$1"
  # Only remember the second-monitor scratch workspaces (6-8); ignore the pinned
  # 9 (Spotify) and 10 (Obsidian) and the first-monitor group.
  (( ws >= 6 && ws <= 8 )) || return 0
  echo "$ws" > "$STATE_FILE"
}

case "${1:-obsidian}" in
  obsidian)
    save_last "$(cur_ws)" || true
    open -a Obsidian            # launches or focuses; on-window-detected keeps it on WS 10
    aerospace workspace "$OBSIDIAN_WS"
    ;;
  spotify)
    save_last "$(cur_ws)" || true
    open -a Spotify
    aerospace workspace "$SPOTIFY_WS"
    ;;
  back|last|prev)
    if [[ -f "$STATE_FILE" ]]; then
      aerospace workspace "$(cat "$STATE_FILE")"
    else
      aerospace workspace 6     # fallback to the first second-monitor workspace
    fi
    ;;
  *)
    echo "Usage: $0 [obsidian|spotify|back]" >&2
    exit 1
    ;;
esac
