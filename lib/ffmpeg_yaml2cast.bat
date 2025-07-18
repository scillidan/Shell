:: Purpose: Convert a YAML file to a casting format, create a GIF from it, and then convert that GIF to MP4.
:: Tools: autocast, agg, ffmpeg
:: Usage: script.bat <input_yaml>

@echo off
setlocal

set input_yaml=%~1
set cast_file=%~2
set gif_file=%~3
set mp4_file=%~4

autocast "%input_yaml%" "%cast_file%"

agg --theme asciinema ^
    --speed 1.5 ^
    --font-family "JetBrainsMono Nerd Font Mono" ^
    --font-size 14 ^
    --fps-cap 30 "%cast_file%" "%gif_file%"

ffmpeg -i "%gif_file%" ^
    -movflags faststart ^
    -pix_fmt yuv420p ^
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" ^
    "%mp4_file%"

endlocal