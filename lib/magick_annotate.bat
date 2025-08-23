:: Purpose: Write annotates to the pictures in a specific format.
:: Tools: magick
:: Usage: file.bat <input_image> <annotate>

@echo off
setlocal

set input_file=%~1
set annotate=%~2

for %%F in ("%input_file%") do set base_name=%%~nF

magick convert "%input_file%" ^
    -undercolor #00000075 ^
    -fill #FFFFFF ^
    -gravity NorthWest ^
    -font "C:\Users\User\Usr\File\Nerd-Sarasa-Merge\MonaspiceNeNFP-SarasaGothicSC-WFMSansSC.ttf" ^
    -pointsize 20 ^
    -interline-spacing 2 ^
    -annotate +10+10 "%annotate%" ^
    "_annot_%base_name%.png"

endlocal