@echo off
REM Optimize PNG files using pngquant
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <img1> <img2> ...

if "%~1"=="" exit /b

for %%I in (%*) do (
    pngquant --force --ordered --speed=1 --quality=85 "%%~I"
)