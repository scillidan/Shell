#!/bin/bash
# Refer to https://github.com/Zeioth/rofi-shortcuts

cat ~/Usr/File/file_rofi-shortcuts/shortcut/*.conf | sort -u | rofi -i -dmenu -p 'shortcut'