@echo off
REM Translate subtitle files (.srt).
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <srt1> <srt2> ...

if "%~1"=="" exit /b

for %%I in (%*) do (
    uv run "%USERHOME%/Usr/Git/Shell/lib/python/tencent_trans_sub.py" --max-qps 5 --source en --target zh --input "%%~I"
)
