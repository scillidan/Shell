@echo off
REM Convert SRT files to VTT format
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <srt1> <srt2> ...

setlocal enabledelayedexpansion

set "srt_to_vtt=%USERPROFILE%\Usr\Git\Shell\lib\python\srt_to_vtt.py"

for %%I in (%*) do (
    set "outputFile=%%~dpnI.vtt"
    python "!srt_to_vtt!" -i "%%~I" -o "!outputFile!"
)

endlocal