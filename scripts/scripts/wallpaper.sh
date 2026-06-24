#!/bin/bash

awww query
if [ $? -eq 1 ] ; then
    awww-daemon
fi
awww img ~/.current_wallpaper --resize fit
