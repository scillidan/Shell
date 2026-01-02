@echo off
REM Dependences: powershell, git
REM Usage:
REM 1. Copy a repo URL
REM 2. script.cmd <path>

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

echo Cloning: %url% into %workdir%
pushd %workdir%
git clone --depth=1 "%url%"
popd

if not errorlevel 1 (
    echo Clone successful!
    echo Run `git fetch --unshallow` for full history
) else (
    echo Clone failed!
    pause
)
