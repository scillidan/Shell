@echo off
REM Dependences: powershell, repomix
REM Install:
REM bun add -g repomix
REM Usage:
REM 1. Copy a repo URL
REM 2. file.cmd <path>

for /f "delims=" %%G in ('powershell -command "Get-Clipboard"') do set "url=%%G"

if "%url%"=="" (
    echo No URL in clipboard
    pause
    exit /b
)

if "%~1"=="" (
    echo No target directory specified
    pause
    exit /b
)

set "workdir=%~1"

echo Packs: %url%
pushd %workdir%
repomix --remote "%url%" --style markdown --output _repomix.md
popd

if not errorlevel 1 (
    echo Packs successful!
) else (
    echo Packs failed!
    pause
)
