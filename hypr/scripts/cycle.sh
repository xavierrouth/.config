#!/bin/bash

# Get the current workspace number
current_workspace=$(hyprctl activeworkspace | grep -oP '(?<=ID )\d+')

shift_amount=$1
move=$2
next_workspace=$((current_workspace + shift_amount))

# echo $current_workspace

# Define workspace range
if [[ current_workspace -ge 6 ]] && [[ current_workspace -le 10 ]]; then
# echo $next_workspace
    # echo "here"
    if [[ next_workspace -eq 11 ]]; then
        next_workspace=6
    elif [[ next_workspace -eq 5 ]]; then
        next_workspace=10
    fi
elif [[ current_workspace -ge 1 ]] && [[ current_workspace -le 5 ]]; then
# echo "here2"
# echo $next_workspace
    if [[ next_workspace -eq 6 ]]; then
        next_workspace=0
    elif [[ next_workspace -eq 0 ]]; then
        next_workspace=5
    fi
fi

# Switch to the next workspace
echo $next_workspace

# If it is set to move, then move workspace

if [[ "$move" = "yes" ]]; then
    # $(hyprctl activewindow | grep)
    hyprctl dispatch movetoworkspace $next_workspace
else
    hyprctl dispatch workspace $next_workspace
fi