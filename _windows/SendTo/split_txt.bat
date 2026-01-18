@echo off
REM Authors: DeepSeek🧙‍♂️, scillidan🤡
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files or dirs > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <file1> <file2> ...

setlocal enabledelayedexpansion

:Process
if "%~1"=="" goto :EOF

set "input=%~1"
set "name=%~n1"
set "ext=%~x1"
if "%ext%"=="" set "ext=.txt"

split -b 10MB "%input%" "%name%_"

set /a count=1
for %%f in ("%name%_*") do (
    set "padded=00!count!"
    set "padded=!padded:~-2!"
    ren "%%f" "%name%_!padded!%ext%"
    set /a count+=1
)

echo Created !count! files
shift
goto :Process
