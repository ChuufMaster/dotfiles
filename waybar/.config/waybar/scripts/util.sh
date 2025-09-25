#!/bin/bash

ascii-bar() {


    while getopts v:i:t:c:wb option
    do
        case "${option}" in
            v|value) value=${OPTARG};;
            i|icon) icon=${OPTARG};;
            t|tooltip) tooltip="$OPTARG";;
            c|colors) colors=${OPTARG};;
            w|waybar) waybar=true;;
            b|border) border=true;;
        esac
    done

    # value=$1
    # icon=$2
    # tooltip=$3
    # colors=$4
    # ASCII bar
    filled=$((value / 10))
    empty=$((10 - filled))
    bar=$(printf '█%.0s' $(seq 1 $filled))
    pad=$(printf '░%.0s' $(seq 1 $empty))
    ascii_bar="[$bar$pad]"

    # Color thresholds
    if [ "$value" -lt 33 ]; then
        fg=${colors[0]:-"#bf616a"}  # red
    elif [ "$value" -lt 66 ]; then
        fg=${colors[1]:-"#fab387"} # orange
    else
        fg=${colors[2]:-"#56b6c2"}  # cyan
    fi
    if border; then
        . ~/scripts/border.sh
        output=$(border "$icon $ascii_bar $value%")
    else
        output="$icon $ascii_bar $value%"
    fi

    # echo "{\"text\":\"<span foreground='$fg'>$icon $ascii_bar $value%</span>\",\"tooltip\":\"$tooltip\"}"
    # echo "{\"text\":\"<span foreground='$fg'>$output</span>\",\"tooltip\":\"$tooltip\"}"

    if $waybar; then
        echo "{\"text\":\"<span foreground='$fg'>$output</span>\",\"tooltip\":\"$tooltip\"}"
    else
        echo "$output"
    fi
}
