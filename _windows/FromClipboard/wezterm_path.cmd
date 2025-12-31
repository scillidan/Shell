@echo off
REM Dependencies: powershell, git
REM Usage: script.cmd [path]

set "target_path=%1"

if "%target_path%"=="" (
    for /f "delims=" %%a in ('powershell -Command "Get-Clipboard"') do set "target_path=%%a"
)

if not defined target_path (
    echo No path provided and clipboard is empty
    pause
    exit /b 1
)

wezterm start --cwd "%target_path%"