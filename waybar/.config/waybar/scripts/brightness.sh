#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────
# Description: Shows current brightness with ASCII bar + tooltip
# Usage: Waybar `custom/brightness` every 2s
# Dependencies: brightnessctl, seq, printf, awk
#  ─────────────────────────────────────────────────────────

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$((brightness * 100 / max_brightness))


# Icon
icon="󰛨"

tooltip="Brightness: $percent%\nDevice: $device"


# Device name (first column from brightnessctl --machine-readable)
device=$(brightnessctl --machine-readable | awk -F, 'NR==1 {print $1}')

. ~/.config/waybar/scripts/util.sh
echo $(ascii-bar -v "$percent" -i "$icon" -t "$tooltip" -w)

# # Build ASCII bar
# filled=$((percent / 10))
# empty=$((10 - filled))
# bar=$(printf '█%.0s' $(seq 1 $filled))
# pad=$(printf '░%.0s' $(seq 1 $empty))
# ascii_bar="[$bar$pad]"
#
#
# # Color thresholds
# if [ "$percent" -lt 20 ]; then
#     fg="#bf616a"  # red
# elif [ "$percent" -lt 55 ]; then
#     fg="#fab387"  # orange
# else
#     fg="#56b6c2"  # cyan
# fi
#
#
# # Tooltip text
#
# # JSON output
# echo "{\"text\":\"<span foreground='$fg'>$icon $ascii_bar $percent%</span>\",\"tooltip\":\"$tooltip\"}"
#
