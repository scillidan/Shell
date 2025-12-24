#!/bin/bash
# 1. Ask for the page number once
# 2. Set default if empty
# Usage:
# ./script.sh <pdf1> <pdf2> ...

read -p "Enter page number (default=1): " page
page=${page:-1}
imgpage=$((page - 1))

for file in "$@"; do
    magick "$file[$imgpage]" "${file%.*}_p${page}.jpg"
done