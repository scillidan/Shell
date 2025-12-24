@echo off
REM Serve ZIM file with Kiwix
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select file > Context Menu > SendTo > script.bat
REM 2. Drag and drop file onto this script
REM 3. script.cmd <zim> ...

if "%~1"=="" (
    exit /b
)

kiwix-serve --address 0.0.0.0 --port 5173 "%~1"