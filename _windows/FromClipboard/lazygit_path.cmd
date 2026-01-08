@echo off
REM Dependencies: powershell, lazygit
REM Usage: file.cmd [path]

set "target_path=%1"

if "%target_path%"=="" (
    for /f "delims=" %%a in ('powershell -Command "Get-Clipboard"') do set "target_path=%%a"
)

if not defined target_path (
    echo No path provided and clipboard is empty
    pause
    exit /b 1
)

lazygit --path "%target_path%"