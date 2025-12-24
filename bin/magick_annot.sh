#!/bin/bash
# Write annotates to the pictures.
# Usage: ./script.sh <img> "<annot>"

input_file="$1"
annotate="$2"
font="/c/Users/User/Usr/Asset/font/SarasaTermSCNerd/SarasaTermSCNerd-Regular.ttf"

base_name=$(basename "$input_file" | cut -d. -f1)

magick "$input_file" \
    -undercolor "#00000050" \
    -fill "#FFFFFF" \
    -gravity SouthWest \
    -font "$font" \
    -pointsize 20 \
    -interline-spacing 2 \
    -annotate +5+5 "$annotate" \
    "_annot_${base_name}.png"