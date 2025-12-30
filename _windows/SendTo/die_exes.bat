@echo off
REM Usage: Open files with Detect It Easy (DiE).
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <exe1> <exe2> ...

setlocal enabledelayedexpansion

for %%I in (%*) do (
    die "%%~I"
)

endlocal