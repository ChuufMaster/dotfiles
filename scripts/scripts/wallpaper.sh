#!/bin/bash

swww query
if [ $? -eq 1 ] ; then
    swww init
fi
swww img ~/.current_wallpaper
