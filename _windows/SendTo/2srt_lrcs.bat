@echo off
REM Convert LRC files to SRT format
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <lrc1> <lrc2> ...

setlocal enabledelayedexpansion

set "lrc_to_srt=%USERPROFILE%\Usr\Git\Shell\lib\python\lrc_to_srt.py"

for %%I in (%*) do (
    set "outputFile=%%~dpnI.srt"
    python "!lrc_to_srt!" "%%~I" "!outputFile!"
)

endlocal