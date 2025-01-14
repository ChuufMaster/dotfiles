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
    ln -sf "$1" "$HOME/.current_wallpaper.jpg"
    cp "$1" "$HOME/.mozilla/firefox/1opdykuv.default-release-1729612380706/chrome/current_wallpaper.jpg"
    # ln -sf "$1" "$HOME/.mozilla/firefox/1opdykuv.default-release-1729612380706//chrome/current_wallpaper.jpg"
}

pywal() {

    wallpaper_path=$(readlink "$HOME/.current_wallpaper")

    check_file "$wallpaper_path"

    wal -n -s -t --cols16 "lighten" -i "$wallpaper_path"

    # Update sway config files and css
    swaync-client --reload-css
    swaync-client --reload-config

    # Update thunderbird using pywalfox
    pywalfox update
}

zathura_update() {
    genzathurarc >$HOME/.config/zathura/zathurarc
}

webcord_update() {
    webcord_config=~/.config/WebCord/Themes
    pywal-discord -p $webcord_config
    mv $webcord_config/pywal-discord-default.theme.css $webcord_config/pywal-discord-default.theme
}

reload_kitty() {
    [ "$1" ] && {
        [ -f "${CONFDIR}/default/kitty.conf" ] || {
            [ -d "${CONFDIR}/default" ] || mkdir -p "${CONFDIR}/default"
            cp "${CONFDIR}/kitty.conf" "${CONFDIR}/default/kitty.conf"
        }
        cp "${CONFDIR}/$1/kitty.conf" "${CONFDIR}/kitty.conf"
    }
    kill -SIGUSR1 $(pidof kitty)
}

set_spicetify() {
    cp -r $HOME/.cache/wal/colors-spicetify.ini $HOME/.config/spicetify/Themes/Pywal
    cd $HOME/.config/spicetify/Themes/Pywal
    mv colors-spicetify.ini color.ini
    spicetify watch -s &
    sleep 1 && pkill spicetify
}

executeCommand "$CHOSEN"
pywal
zathura_update
webcord_update
reload_kitty
set_spicetify
# ~/scripts/reload-waybar.sh

swww query
if [ $? -eq 1 ]; then
    ~/scripts/wallpaper.sh
fi
