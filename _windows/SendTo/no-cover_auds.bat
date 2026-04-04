@echo off
REM 1. Remove cover picture from MP3 format
REM 2. Delete original if conversion succeeded
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <mp31> <mp32> ...

setlocal enabledelayedexpansion

for %%I in (%*) do (
    set "originalFile=%%~fI"
    set "outputFile=%%~dpnI.mp3"
    set "tempFile=%%~dpnI_temp_%%~nI.mp3"
    set "backupFile=%%~dpnI.bak"

    echo Processing: %%~nxI

    ffmpeg -i "!originalFile!" -map 0:a -c:a copy -map_metadata -1 "!tempFile!"
    if errorlevel 1 (
        echo FFmpeg failed
        del /f "!tempFile!" 2>nul
    ) else (
        move /Y "!originalFile!" "!backupFile!" >nul
        move /Y "!tempFile!" "!outputFile!" >nul
        del /f "!backupFile!" >nul
        echo Done: !outputFile!
    )
)
