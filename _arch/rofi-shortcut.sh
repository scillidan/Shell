#!/bin/bash
# Refer to https://github.com/Zeioth/rofi-shortcuts

cat ~/Usr/File/file_rofi-shortcuts/{shortcut,shortcut_arch,shortcut_dev}/*.conf | sort -u | rofi -i -dmenu -p 'shortcut'