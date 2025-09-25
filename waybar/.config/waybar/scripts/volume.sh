#!/bin/bash
# ── volume.sh ─────────────────────────────────────────────
# Description: Shows current audio volume with ASCII bar + tooltip
# Usage: Waybar `custom/volume` every 1s
# Dependencies: wpctl, awk, bc, seq, printf
# ───────────────────────────────────────────────────────────

# Get raw volume and convert to int
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
vol_int=$(echo "$vol_raw * 100" | bc | awk '{ print int($1) }')

# Check mute status
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

# Get default sink description (human-readable)
sink=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep '\*' | cut -d'.' -f2- | sed 's/^\s*//; s/\[.*//')

# Icon logic
if [ "$is_muted" = true ]; then
  icon=""
  vol_int=0
elif [ "$vol_int" -lt 50 ]; then
  icon=""
else
  icon=""
fi


# Tooltip text
if [ "$is_muted" = true ]; then
  tooltip="Audio: Muted\nOutput: $sink"
else
  tooltip="Audio: $vol_int%\nOutput: $sink"
fi

. ~/.config/waybar/scripts/util.sh
echo $(ascii-bar -v $vol_int -i $icon -t "$tooltip" -w)
