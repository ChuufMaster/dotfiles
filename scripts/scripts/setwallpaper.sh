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
    cp "$1" "$HOME/.mozilla/firefox/1opdykuv.default-release-1729612380706/chrome/current_wallpaper.jpg"
    # ln -sf "$1" "$HOME/.mozilla/firefox/1opdykuv.default-release-1729612380706//chrome/current_wallpaper.jpg"
}

pywal() {

    wallpaper_path=$(readlink "$HOME/.current_wallpaper")

    check_file "$wallpaper_path"

    wal -n -i "$wallpaper_path" -s -t

    # Update sway config files and css
    swaync-client --reload-css
    swaync-client --reload-config

    # Update thunderbird using pywalfox
    pywalfox update
}

zathura_update() {
    genzathurarc > $HOME/.config/zathura/zathurarc
}

webcord_update() {
    webcord_config=~/.config/WebCord/Themes
    pywal-discord -p $webcord_config
    mv $webcord_config/pywal-discord-default.theme.css $webcord_config/pywal-discord-default.theme
}

executeCommand "$CHOSEN"
pywal
zathura_update
webcord_update
