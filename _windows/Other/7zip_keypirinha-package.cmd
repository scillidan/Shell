@echo off
REM 1. Create zip archive excluding .git folder
REM 2. Rename zip to keypirinha-package
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select the keypirinha-package directory(s) > Context Menu > SendTo > script.bat
REM 2. Drag and drop directory(s) onto this script
REM 3. script.cmd <directory(s)>

if "%~1"=="" exit /b
if not exist "%~1\" exit /b

7z a -x!.git "%~1.zip" "%~1\*"
move /Y "%~1.zip" "%~1.keypirinha-package"