@echo off
REM Convert multi-line subtitle content to single line.
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <srt1> <srt2> ...

if "%~1"=="" exit /b

for %%I in (%*) do (
    python "%USERHOME%/Usr/Git/Shell/lib/python/srt_inline.py" "%%~I"
)
