@echo off
REM 1. Remove cover picture from MP3 format
REM 2. Delete original if conversion succeeded
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <mp31> <mp32> ...

:parse_args
if "%~1"=="" goto :end_parse
set "originalFile=%~f1"
set "outputFile=%~dpn1.mp3"
set "tempFile=%~dpn1_temp_%~n1.mp3"
set "backupFile=%~dpn1.bak"

echo Processing: %~nx1

setlocal enabledelayedexpansion
ffmpeg -i "!originalFile!" -map 0:a -c:a copy -map_metadata 0 "!tempFile!"
if errorlevel 1 (
    echo FFmpeg failed
    del /f "!tempFile!" 2>nul
) else (
    move /Y "!originalFile!" "!backupFile!" >nul
    move /Y "!tempFile!" "!outputFile!" >nul
    del /f "!backupFile!" 2>nul
    echo Done: !outputFile!
)
endlocal
shift
goto :parse_args
:end_parse
