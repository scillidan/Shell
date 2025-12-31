#!/bin/bash
# Create montage with background and spacing from images.
# Authors: mistral.ai🧙‍♂️, scillidan🤡
# Usage: ./script.sh --grid <col>x<row> <img1> <img2> ...

output_montage="_montage.png"

# Default values
grid_cols=1
grid_rows=1
border=1
background=none

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --grid)
            IFS='x' read -r grid_cols grid_rows <<< "$2"
            if [ -z "$grid_rows" ]; then
                grid_rows=$grid_cols
            fi
            shift 2
            ;;
        *)
            files+=("$1")
            shift
            ;;
    esac
done

# Calculate max width and height among all images
max_width=0
max_height=0
for file in "${files[@]}"; do
    read width height < <(magick identify -format "%w %h" "$file")
    if (( width > max_width )); then
        max_width=$width
    fi
    if (( height > max_height )); then
        max_height=$height
    fi
done

# Resize all images to the max width/height while maintaining aspect ratio
resized_files=()
for file in "${files[@]}"; do
    read width height < <(magick identify -format "%w %h" "$file")
    resized_file="_resized_${file}"
    magick "$file" -resize "${max_width}x${max_height}" -gravity center -extent "${max_width}x${max_height}" -background none "$resized_file"
    resized_files+=("$resized_file")
done

# Create montage with transparent background and spacing
echo "Creating montage with grid ${grid_cols}x${grid_rows}..."
magick montage "${resized_files[@]}" \
    -tile "${grid_cols}x${grid_rows}" \
    -background ${background} \
    -geometry "${max_width}x${max_height}+${border}+${border}" \
    "$output_montage"

# Trim extra transparent space
magick "$output_montage" -trim +repage "$output_montage"

echo "Montage created: $output_montage"

echo "Clear:${resized_files[@]}"
rm ${resized_files[@]}

echo "Done!"