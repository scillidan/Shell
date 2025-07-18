:: Purpose: Create an image with a caption using specified font and formatting.
:: Tools: magick
:: Usage: file.bat <size> "<caption>"

@echo off
setlocal enabledelayedexpansion

set size=%~1
set caption=%~2
set kebab_caption=!caption: =-!
set output_file="%kebab_caption%.png"
set font_path="C:\\Users\\User\\File\\Nerd-Sarasa-Merge\\MonaspiceNeNFP-SarasaGothicSC-WFMSansSC.ttf"

magick convert -size %size% ^
    -background #000000 ^
    -fill #fffff8 ^
    -font %font_path% ^
    -gravity Center ^
    -pointsize 20 ^
    -interline-spacing 2 ^
    caption:"%caption%" ^
    %output_file%

endlocal