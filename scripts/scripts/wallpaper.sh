#!/bin/bash

swww query
if [ $? -eq 1 ] ; then
    swww-daemon
fi
swww img ~/.current_wallpaper --resize fit
