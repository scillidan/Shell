@echo off
REM Dependencies: powershell, git, git-sync
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

pushd "%target_path%"

echo Running git-sync...
call git-sync.cmd

popd