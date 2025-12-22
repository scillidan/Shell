#!/bin/bash

# Check parameters
if [ $# -lt 2 ]; then
    echo "Usage: $(basename "$0") <input_file> <annotation_text> [min_height] [max_height]"
    echo "Example: $(basename "$0") image.jpg 'Annotation text' 600 1200"
    exit 1
fi

input_file="$1"
annotate="$2"
min_height="${3:-600}"
max_height="${4:-1200}"

# Get base filename
base_name=$(basename "$input_file")
base_name="${base_name%.*}"
output_file="_annot_${base_name}.png"

# Get image dimensions
dimensions=$(magick identify -format "%w %h" "$input_file")
width=$(echo $dimensions | cut -d' ' -f1)
height=$(echo $dimensions | cut -d' ' -f2)

# Calculate target dimensions
target_height=$height
if [ $height -lt $min_height ]; then
    target_height=$min_height
elif [ $height -gt $max_height ] && [ $max_height -gt 0 ]; then
    target_height=$max_height
fi

# Calculate scaling factor
if [ $height -ne $target_height ]; then
    scale_factor=$(echo "$target_height / $height" | bc -l)
    target_width=$(echo "$width * $scale_factor" | bc | cut -d. -f1)
else
    target_width=$width
fi

# Calculate font size intelligently
# Use 5% of the shorter side as reference
if [ $target_width -lt $target_height ]; then
    reference_size=$target_width
else
    reference_size=$target_height
fi

# Font size = 3.5% of shorter side, limited to 12-48px
font_size=$(echo "$reference_size * 0.035" | bc)
font_size=$(printf "%.0f" $font_size)

# Limit font size range
if [ $font_size -lt 12 ]; then
    font_size=12
elif [ $font_size -gt 48 ]; then
    font_size=48
fi

# Calculate line spacing
interline_spacing=$(echo "$font_size * 0.3" | bc | cut -d. -f1)
if [ -z "$interline_spacing" ] || [ "$interline_spacing" -lt 2 ]; then
    interline_spacing=2
fi

# Calculate margin
margin=$(echo "$font_size * 0.5" | bc | cut -d. -f1)
if [ -z "$margin" ] || [ "$margin" -lt 10 ]; then
    margin=10
fi

# Process image
echo "Processing: $input_file"
echo "Original dimensions: ${width}x${height}"
echo "Target dimensions: ${target_width}x${target_height}"
echo "Font size: ${font_size}px"
echo "Margin: ${margin}px"

if [ $height -ne $target_height ]; then
    # Scale image
    magick convert "$input_file" \
        -resize "${target_width}x${target_height}" \
        -undercolor "#00000075" \
        -fill "#FFFFFF" \
        -gravity NorthWest \
        -pointsize $font_size \
        -interline-spacing $interline_spacing \
        -annotate +${margin}+${margin} "$annotate" \
        "$output_file"
else
    # Process without scaling
    magick convert "$input_file" \
        -undercolor "#00000075" \
        -fill "#FFFFFF" \
        -gravity NorthWest \
        -pointsize $font_size \
        -interline-spacing $interline_spacing \
        -annotate +${margin}+${margin} "$annotate" \
        "$output_file"
fi

echo "✓ Processing completed: $output_file"