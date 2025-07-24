#!/bin/bash
pkill -SIGUSR1 waybar
# if pgrep -x waybar > /dev/null; then
#     pkill waybar
# else
#     waybar &
# fi