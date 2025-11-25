#!/bin/bash
set -euo pipefail

OBSIDIAN_WS=10
STATE_FILE="$HOME/.config/hypr/obsidian_last_workspace"

get_active_ws() {
  hyprctl activeworkspace -j | jq -r '.id'
}

# New: get the workspace currently on the 6–10 monitor (2nd monitor) via monitors' activeWorkspace.
get_second_monitor_ws() {
  hyprctl monitors -j | jq -r '
    [ .[] | select(.activeWorkspace.id >= 6 and .activeWorkspace.id <= 10) | .activeWorkspace.id ][0] // empty
  '
}

# Removed per-monitor logic; we only track the last non-Obsidian workspace ID.
save_last_ws() {
  local ws="$1"
  # Track only workspaces 6-9; ignore 1-5 and 10 (Obsidian)
  if (( ws < 6 || ws > 10 || ws == OBSIDIAN_WS )); then
    return
  fi
  mkdir -p "$(dirname "$STATE_FILE")"
  echo "$ws" > "$STATE_FILE"
}

load_last_ws() {
  [[ -f "$STATE_FILE" ]] || return 0
  # Be tolerant of any previous format: take the last field of the last line.
  local v
  v=$(awk 'NF {last=$NF} END {if (last) print last}' "$STATE_FILE") || true
  # Ensure it's a valid workspace in 6-9 (exclude 10/Obsidian)
  if [[ -n "${v:-}" && "$v" =~ ^[0-9]+$ ]] && (( v >= 6 && v <= 10 && v != OBSIDIAN_WS )); then
    echo "$v"
  fi
}

focus_or_start_obsidian() {
  if pgrep -x "obsidian" >/dev/null; then
    hyprctl dispatch focuswindow "class:obsidian"
    return
  fi
  obsidian & disown
  for i in {1..50}; do
    sleep 0.1
    if hyprctl clients -j | jq -e '.[] | select(.class == "obsidian")' >/dev/null; then
      break
    fi
  done
  hyprctl dispatch focuswindow "class:obsidian"
}

case "${1:-obsidian}" in
  obsidian)
    CUR_WS="$(get_second_monitor_ws)"
    [[ -n "$CUR_WS" ]] && save_last_ws "$CUR_WS"

    focus_or_start_obsidian
    hyprctl dispatch movetoworkspace "$OBSIDIAN_WS"
    # Do not move workspace 10 across monitors; 1-5 and 6-10 are pinned.
    hyprctl dispatch workspace "$OBSIDIAN_WS"
    ;;
  back|last|prev)
    LAST_WS="$(load_last_ws || true)"
    if [[ -n "${LAST_WS:-}" && "$LAST_WS" -ne "$OBSIDIAN_WS" ]]; then
      hyprctl dispatch workspace "$LAST_WS"
    else
      # Fallback to first in the 6-10 range if nothing valid is saved and we're on Obsidian
      CUR_WS="$(get_active_ws)"
      [[ "$CUR_WS" -eq "$OBSIDIAN_WS" ]] && hyprctl dispatch workspace 6
    fi
    ;;
  *)
    echo "Usage: $0 [obsidian|back]" >&2
    exit 1
    ;;
esac