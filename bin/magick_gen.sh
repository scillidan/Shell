#!/bin/bash
# Create an image with a caption.
# Usage: ./file.sh <img_size> "<caption>"

font="/c/Users/User/Usr/Asset/font/SarasaTermSCNerd/SarasaTermSCNerd-Regular.ttf"
img_size=$1
caption="$2"
kebab_caption=$(echo "$caption" | tr ' ' '-')
output_file="${kebab_caption}.png"

magick -size "${img_size}" \
  -background "#000000" \
  -fill "#fffff8" \
  -font "$font" \
  -gravity Center \
  -pointsize 20 \
  -interline-spacing 2 \
  caption:"$caption" \
  "$output_file"