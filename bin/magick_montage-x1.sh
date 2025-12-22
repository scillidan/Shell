#!/bin/bash
# Simple montage script similar to original batch file

output_montage="_montage.png"
output_jpeg="_montage_.jpg"

echo "Creating montage from provided images..."

# Create montage
magick montage "$@" \
    -density 300 \
    -tile x1 \
    -geometry +1+1 \
    -background "#000" \
    "$output_montage"

# Check if montage was created successfully
if [ ! -f "$output_montage" ]; then
    echo "Error: Failed to create montage" >&2
    exit 1
fi

echo "Montage created: $output_montage"

# Convert to JPEG
magick convert "$output_montage" \
    -border 1 \
    -bordercolor "#000" \
    -strip \
    -interlace Plane \
    -quality 85 \
    "$output_jpeg"

echo "JPEG created: $output_jpeg"
echo "Done!"