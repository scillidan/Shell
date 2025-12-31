#!/bin/bash
# PDF page extract.
# Authors: DeepSeek🧙‍♂️, scillidan🤡
# Usage:
# (Linux) ./file.sh <input_pdf> <output_dir> <img_format> <dpi>
# (Windows) bash file.sh <input_pdf> <output_dir> <img_format> <dpi>

INPUT_PDF="${1}"
OUTPUT_DIR="${2:-./_extract}"
FORMAT="${3:-jpg}"
DENSITY="${4:-300}"
QUALITY="${5:-100}"

if [ -z "$INPUT_PDF" ]; then
    echo "Please specify an input PDF file"
    exit 1
fi

if [ ! -f "$INPUT_PDF" ]; then
    echo "Error: PDF file '$INPUT_PDF' not found"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

BASENAME=$(basename "$INPUT_PDF" .pdf)

echo "Starting PDF extraction..."
echo "Input: $INPUT_PDF"
echo "Output: $OUTPUT_DIR"
echo "Format: $FORMAT"
echo "Density: $DENSITY dpi"

magick -density "$DENSITY" "$INPUT_PDF" \
       -quality "$QUALITY" \
       -antialias \
       -colorspace RGB \
       -scene 1 \
       "$OUTPUT_DIR/${BASENAME}_p%03d.${FORMAT}"

if [ $? -eq 0 ]; then
    COUNT=$(ls "$OUTPUT_DIR"/*."$FORMAT" 2>/dev/null | wc -l)
    echo "✅ Successfully extracted $COUNT pages"
    echo "📁 Files saved in: $OUTPUT_DIR"
    echo "📄 Files are numbered from 001"
else
    echo "❌ Extraction failed"
    exit 1
fi