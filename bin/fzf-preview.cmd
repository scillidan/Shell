REM Base on https://github.com/chrisant996/clink-fzf/blob/main/fzf-preview.cmd

@echo off

setlocal enabledelayedexpansion

if "%~1" == "" goto :end

set ARG=%~1
set TMP_IMG=%TEMP%\_fzf_preview
set EXT=%~x1
set IMG_PREVIEW=chafa -f symbols --animate=off --clear --size x25

if /i "%EXT%" == ".pdf" (
    pdftoppm -jpeg -singlefile -scale-to 400 "%ARG%" "%TMP_IMG%.jpg"
    %IMG_PREVIEW% "%TMP_IMG%.jpg"
) else if /i "%EXT%" == ".epub" (
    REM Pre-release on https://github.com/scillidan/epub-thumbnailer
    epub-thumbnailer "%ARG%" "%TMP_IMG%.png" 400
    %IMG_PREVIEW% "%TMP_IMG%.png"
) else (
    echo %EXT% | findstr /i ".png .jpg .jpeg .gif .bmp .tiff .tif .webp .svg .ico" >nul
    if !errorlevel! equ 0 (
        %IMG_PREVIEW% "%ARG%"
    ) else (
        bat --color=always --style=numbers,changes --line-range=:500 "%ARG%" 2>nul || type "%ARG%"
    )
)

:end
exit /b 0