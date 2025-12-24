@echo off
REM 1. Ask for page number once
REM 2. Set default if empty
REM 3. Convert to 0-based index for ImageMagick
REM 4. Process all files
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <pdf1> <pdf2> ...

setlocal enabledelayedexpansion

set /p page="Enter page number (default=1): "
if "!page!"=="" set "page=1"
set /a imgpage=page-1

for %%F in (%*) do (
    magick "%%F[!imgpage!]" "%%~nF_p!page!.jpg"
)