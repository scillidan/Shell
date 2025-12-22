@echo off
REM Example
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <file1> <file2> ...

setlocal enabledelayedexpansion

for %%I in (%*) do (
		set "outputFile=%%~dpnI"
    <bin> "%%~I" "!outputFile!"
    if exist "!outputFile!" del "%%~I"
)