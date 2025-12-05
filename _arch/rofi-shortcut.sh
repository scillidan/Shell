#!/bin/bash
# https://github.com/Zeioth/rofi-shortcuts

cat ~/Usr/Git/File/bin/_arch_rofi-shortcuts/shortcut/*.conf | sort -u | rofi -i -dmenu -p 'shortcut'