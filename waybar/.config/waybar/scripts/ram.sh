#!/bin/bash


ram_usage=$(echo "scale=0; $(free | grep Mem | awk '{print $3/$2}')*100/1"  | bc)

icon="󰍛"

tooltip="$(qalc -t "$(free --giga | grep Mem | awk '{print $3}') gigabytes")"
colors=("#29f430" "#f28500" "#f20c00")

. ~/.config/waybar/scripts/util.sh
echo $(ascii-bar -v $ram_usage -i $icon -t "$tooltip" -c $colors -w)
# echo $ram_usage
