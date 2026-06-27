#!/bin/bash
# Power menu, replacing waybar custom/exit (wlogout). Minimal logout/lock/shutdown
# chooser via AppleScript. Customize to taste.
choice=$(osascript -e 'choose from list {"Lock", "Sleep", "Log Out", "Restart", "Shut Down"} with prompt "Power" default items {"Lock"}')
case "$choice" in
    Lock)      pmset displaysleepnow ;;
    Sleep)     pmset sleepnow ;;
    "Log Out") osascript -e 'tell application "System Events" to log out' ;;
    Restart)   osascript -e 'tell application "System Events" to restart' ;;
    "Shut Down") osascript -e 'tell application "System Events" to shut down' ;;
esac
