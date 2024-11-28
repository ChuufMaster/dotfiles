#!/usr/bin/env bash

PREVIEW=true

rofi -theme ~/.config/rofi/themes/wallpaper.rasi \
    -show filebrowser \
    -filebrowser-command '/home/chuufmaster/scripts/setwallpaper.sh' \
    -filebrowser-directory ~/wallpapers
