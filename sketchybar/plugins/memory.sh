#!/bin/bash
# Used/total RAM in GB, replacing waybar memory module.
total=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
# Pages: app + wired + compressed are "used".
pagesize=$(sysctl -n hw.pagesize)
used_pages=$(vm_stat | awk -v ps="$pagesize" '
    /Pages active/      {a=$3}
    /Pages wired/       {w=$4}
    /Pages occupied by compressor/ {c=$5}
    END {gsub("[^0-9]","",a); gsub("[^0-9]","",w); gsub("[^0-9]","",c); print a+w+c}')
used=$(echo "scale=1; $used_pages * $pagesize / 1024 / 1024 / 1024" | bc)
sketchybar --set "$NAME" label="${used}G/${total}G"
