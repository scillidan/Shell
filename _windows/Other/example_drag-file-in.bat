rem https://stackoverflow.com/questions/61606077/trying-to-convert-magick-to-a-bat-to-drag-and-drop
rem Purpose: Convert an image to multiple 32x32 BMP tiles using ImageMagick.
rem Tools: magick
rem Usage: file.bat <image_file>

@echo off

pushd "%~dp1"

magick "%~1" ^
   -set filename:0 "%%[t]" ^
   -size 320x320 ^
   -crop 32x32 ^
      "%%[filename:0]_%%03d.bmp"

popd

exit /b