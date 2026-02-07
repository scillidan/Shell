@echo off
REM Generate thumbnails (screenshots) from video files.
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <vid1> <vid2> ...

if "%~1"=="" exit /b

for %%I in (%*) do (
    mtn -c 4 -r 4 -w 1920 -g 8 -k ffffff -b 0.80 -D 12 -i -t -j 90 -o _thumb.jpg -Z -P "%%~I"
)