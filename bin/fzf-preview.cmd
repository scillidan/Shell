REM Base on https://github.com/chrisant996/clink-fzf/blob/main/fzf-preview.cmd

@echo off

setlocal enabledelayedexpansion

if "%~1" == "" goto :end

set ARG=%~1
set TMP_IMG=%TEMP%\_fzf_preview
set EXT=%~x1
set IMG_PREVIEW=chafa -f symbols --animate=off --clear --size x25

if /i "%EXT%" == ".pdf" (
    pdftoppm -jpeg -singlefile -scale-to 400 "%ARG%" "%TMP_IMG%"
    %IMG_PREVIEW% "%TMP_IMG%.jpg"
    goto :end
)

if /i "%EXT%" == ".epub" (
    rem Pre-release on https://github.com/scillidan/epub-thumbnailer
    epub-thumbnailer "%ARG%" "%TMP_IMG%.png" 400
    %IMG_PREVIEW% "%TMP_IMG%.png"
    goto :end
)

echo %EXT% | findstr /i ".mp4 .mkv .avi .mp3 .ogg .flac .wav" >nul
if !errorlevel! equ 0 (
    ffmpeg -i "%ARG%" -vframes 1 -q:v 2 -y "%TMP_IMG%.jpg"
    %IMG_PREVIEW% "%TMP_IMG%.jpg"
    del "%TMP_IMG%.jpg"
    mediainfo "%ARG%"
    goto :end
)

echo %EXT% | findstr /i ".png .jpg .jpeg .gif .bmp .tiff .tif .webp .svg .ico" >nul
if !errorlevel! equ 0 (
    %IMG_PREVIEW% "%ARG%"
    goto :end
)

bat --color=always --style=numbers,changes --line-range=:500 "%ARG%" 2>nul || type "%ARG%"

:end
exit /b 0