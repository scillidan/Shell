@echo off
REM 1. Optimize and resize image using yoga
REM 2. Delete original if conversion succeeded
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <img1> <img2> ...

setlocal enabledelayedexpansion

if "%~1"=="" exit /b

for %%I in (%*) do (
    set "outputFile=%%~dpI_yoga_%%~nI.png"

    yoga image --resize 1920 "%%~I" "!outputFile!"

    if exist "!outputFile!" del "%%~I"
)

endlocal