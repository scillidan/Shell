@echo off
REM 1. Optimize and resize image using yoga and imagemagick
REM 2. Delete original if conversion succeeded
REM 3. Resize to height 1080 if original height exceeds 1080
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <img1> <img2> ...

setlocal enabledelayedexpansion

if "%~1"=="" exit /b

for %%I in (%*) do (
    set "inputFile=%%~I"
    set "inputExt=%%~xI"
    set "inputName=%%~nI"
    set "inputDrive=%%~dI"
    set "inputPath=%%~pI"

    if /i "!inputExt!"==".jpg" (
        set "outputExt=.jpg"
    ) else (
        set "outputExt=.png"
    )

    set "outputFile=!inputDrive!!inputPath!_yoga_!inputName!!outputExt!"
    set "tempFile=!inputDrive!!inputPath!_temp_!inputName!!inputExt!"

    for /f "tokens=*" %%a in ('magick identify -format "%%h" "%%~I" 2^>nul') do set "imgHeight=%%a"

    if "!imgHeight!"=="" set "imgHeight=0"

    if !imgHeight! gtr 1080 (
        magick "%%~I" -resize x1080 "!tempFile!" 2>nul
        if exist "!tempFile!" (
            call yoga image "!tempFile!" "!outputFile!" 2>nul
            del "!tempFile!" 2>nul
        )
    ) else (
        call yoga image "%%~I" "!outputFile!" 2>nul
    )

    if exist "!outputFile!" del "%%~I" 2>nul
)

endlocal