#!/bin/bash
# Purpose: Export a specific page from PDF files as JPEG images using ImageMagick.
# Usage: ./file.sh <input_pdf_files>

if [ "$#" -eq 0 ]; then
	echo "Usage: $0 <input_pdf_files>"
	exit 1
fi

for pdf_file in "$@"; do
	read -p "Enter the page number to export (default is 1): " pageNum

	if [ -z "$pageNum" ]; then
		pageNum=1 # Set default page number to 1
	else
		pageNum=$((pageNum - 1)) # Convert to zero-based index
	fi

	filename=$(basename "$pdf_file" .pdf)
	magick convert -density 300 "${pdf_file}[$pageNum]" -flatten -quality 90 "${filename}.jpg"
done
