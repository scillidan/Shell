:: Purpose: Generate a complementary color image from a given PNG file.
:: Tools: magick
:: Usage: file.bat <input_image>

@echo off
setlocal

set input_file=%~1

magick convert "%input_file%" ^
    -channel RGB ^
    -negate "_cmos_.png"

endlocal