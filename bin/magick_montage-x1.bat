:: Purpose: Create a montage from images and convert it to a high-quality JPEG.
:: Tools: magick
:: Usage: montage.bat <image_files>

@echo off
setlocal

set output_montage=_montage.png
set output_jpeg=_montage_.jpg

magick montage %* ^
    -density 300 ^
    -tile x1 ^
    -geometry +1+1 ^
    -background #000 ^
    "%output_montage%"

magick convert "%output_montage%" ^
    -border 1 ^
    -bordercolor #000 ^
    -strip ^
    -interlace Plane ^
    -quality 0.85 ^
    "%output_jpeg%"

endlocal