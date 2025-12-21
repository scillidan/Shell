#!/bin/bash
# Refer to https://github.com/Zeioth/rofi-shortcuts

cat ~/Usr/File/file_rofi-shortcuts/{cheatsheet,cheatsheet_2zh}/*.conf | sort -u | rofi -i -dmenu -p 'cheatsheet'