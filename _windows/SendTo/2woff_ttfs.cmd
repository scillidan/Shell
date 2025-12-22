@echo off
REM 1. Generate WOFF file using webify
REM 2. Convert WOFF to WOFF2 using ttf2woff2
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <ttf1> <ttf2> ...

setlocal enabledelayedexpansion

for %%I in (%*) do (
    if exist "%%~I" (
        set "woff=%%~dpnI.woff"
        set "woff2=%%~dpnI.woff2"

        webify --no-eot --no-svg "%%~I"
        cat "!woff!" | ttf2woff2 > "!woff2!"
    )
)