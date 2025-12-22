#!/bin/bash
# Export a specific page from PDF files as JPEG images
# Usage: ./script.sh <pdf1> <pdf2> ...

for pdf_file in "$@"; do
    # Ask for page number for each PDF
    read -p "Page number for $(basename "$pdf_file") (default:1): " pageNum

    # Set default page number to 1 if empty
    if [ -z "$pageNum" ]; then
        pageNum=0  # Zero-based index for page 1
    else
        pageNum=$((pageNum - 1))  # Convert to zero-based index
    fi

    # Generate output filename (same name with .jpg extension)
    filename=$(basename "$pdf_file" .pdf)

    # Convert PDF page to JPEG
    magick convert -density 300 "${pdf_file}[$pageNum]" -flatten -quality 90 "${filename}.jpg"
done