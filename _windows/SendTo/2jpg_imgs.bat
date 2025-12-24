@echo off
REM 1. Convert image files to JPEG format
REM 2. Delete original if conversion succeeded
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <img1> <img2> ...

setlocal enabledelayedexpansion

for %%I in (%*) do (
    set "outputFile=%%~dpnI.jpg"

    magick convert "%%~I" -quality 90 "!outputFile!"

    if exist "!outputFile!" del "%%~I"
)