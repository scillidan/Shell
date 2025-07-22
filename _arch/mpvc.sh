#!/bin/bash

# Set variables
MPV_CONF="$HOME/Usr/Git/dotfiles/.config/mpv"
MPVC_VIDEO="$HOME/Usr/Data/mpvc_video"
MPVC_MUSIC="$HOME/Usr/Data/mpvc_music"
MPVC_MANGA="$HOME/Usr/Data/mpvc_manga"

config="$1"

if [ "$config" == "video" ]; then
    CONFIG_DIR="$MPVC_VIDEO"
elif [ "$config" == "music" ]; then
    CONFIG_DIR="$MPVC_MUSIC"
elif [ "$config" == "manga" ]; then
    CONFIG_DIR="$MPVC_MANGA"
else
    echo "Invalid config"
    exit 1
fi

mpv --config-dir="$CONFIG_DIR" --force-window --keep-open=yes "$2"