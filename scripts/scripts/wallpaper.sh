#!/bin/bash

# Directory containing images
IMAGE_DIR="$HOME/.config/hypr/wallpapers"

# Select two random images
IMAGE1=$(find "$IMAGE_DIR" -type f | shuf -n 1)
IMAGE2=$(find "$IMAGE_DIR" -type f | shuf -n 1)

# Use the first image for DP-1
hyprctl hyprpaper preload "$IMAGE1"
hyprctl hyprpaper wallpaper "DP-1,$IMAGE1"

# Use the second image for HDMI-A-1
hyprctl hyprpaper preload "$IMAGE2"
hyprctl hyprpaper wallpaper "HDMI-A-1,$IMAGE2"
