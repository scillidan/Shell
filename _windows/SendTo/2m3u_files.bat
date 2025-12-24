@echo off
REM Create an M3U playlist from files.
REM Authors: GPT-4o mini🧙‍♂️, scillidan🤡
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <file1> <file2> ...

rem Set code page to UTF-8
chcp 65001 > nul

setlocal enabledelayedexpansion

set "output_file=playlist.m3u"

if "%~1"=="" (
    echo No file selected.
    exit /b
)

if exist "%output_file%" del "%output_file%"

:loop
for %%F in (%*) do (
    if exist "%%F" (
        echo Processing file: %%F
        echo #EXTM3U >> "%output_file%"
        echo %%~fF >> "%output_file%"
    ) else (
        echo "%%F" does not exist.
    )
)

echo Done creating playlists.
endlocal

pause