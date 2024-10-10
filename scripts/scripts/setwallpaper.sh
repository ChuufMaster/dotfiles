#!/bin/bash

FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"
CHOSEN="$1"

executeCommand() {

  if command -v swww &>/dev/null; then
    swww img "$1" ${SWWW_PARAMS}

  elif command -v swaybg &>/dev/null; then
    swaybg -i "$1" &
  
  else
    echo "Neither swww nor swaybg are installed."
    exit 1
  fi

  ln -sf "$1" "$HOME/.current_wallpaper"
}

pywal(){

  wallpaper_path=$(readlink "$HOME/.current_wallpaper")

  check_file "$wallpaper_path"

  wal -i "$wallpaper_path" -s -t

  # Update sway config files and css
  swaync-client --reload-css
  swaync-client --reload-config

  # Update thunderbird using pywalfox
  pywalfox update
}

executeCommand "$CHOSEN"
pywal
