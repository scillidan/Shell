#!/bin/bash

# Check parameters
if [ $# -lt 2 ]; then
    echo "Usage: $(basename "$0") <size> <caption> [output_file]"
    echo "Example: $(basename "$0") 800x600 \"Hello World\""
    echo "Example: $(basename "$0") 800x600 \"Hello World\" output.png"
    exit 1
fi

size="$1"
caption="$2"
output_file="${3:-}"

# Get dimensions from size parameter
IFS='x' read -r width height <<< "$size"

# Create kebab-case filename from caption if output file not specified
if [ -z "$output_file" ]; then
    kebab_caption=$(echo "$caption" | tr ' ' '-' | tr -cd '[:alnum:]-' | tr '[:upper:]' '[:lower:]')
    output_file="${kebab_caption}.png"
fi

# Smart font size calculation based on dimensions
# Use 5% of the shorter side as base font size
if [ $width -lt $height ]; then
    reference_size=$width
else
    reference_size=$height
fi

font_size=$((reference_size * 5 / 100))

# Ensure font size is reasonable
if [ $font_size -lt 12 ]; then
    font_size=12
elif [ $font_size -gt 48 ]; then
    font_size=48
fi

# Calculate line spacing (20% of font size)
line_spacing=$((font_size * 20 / 100))
if [ $line_spacing -lt 2 ]; then
    line_spacing=2
fi

# Calculate padding (10% of reference size)
padding=$((reference_size * 10 / 100))
if [ $padding -lt 20 ]; then
    padding=20
fi

# Adjust size for padding
padded_width=$((width - 2 * padding))
padded_height=$((height - 2 * padding))

echo "Creating caption image: $output_file"
echo "Dimensions: ${width}x${height}"
echo "Font size: ${font_size}px"
echo "Line spacing: ${line_spacing}px"
echo "Padding: ${padding}px"

# Use caption: prefix for multi-line text
magick convert -size "${padded_width}x${padded_height}" \
    -background "#000000" \
    -fill "#fffff8" \
    -gravity Center \
    -pointsize $font_size \
    -interline-spacing $line_spacing \
    caption:"$caption" \
    -bordercolor "#000000" \
    -border ${padding} \
    "$output_file"

echo "✓ Image created: $output_file"