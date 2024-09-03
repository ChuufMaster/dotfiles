#!/bin/bash
killall -9 waybar
sleep 1
waybar &
swaync-client --reload-css
swaync-client --reload-config
