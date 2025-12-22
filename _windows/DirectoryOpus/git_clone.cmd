@echo off
REM Clone a Git repository from the clipboard.
REM Dependences: powershell, git
REM Usage: script.cmd

for /f "delims=" %%G in ('powershell -command "Get-Clipboard"') do set "url=%%G"

if "%url%"=="" (
    echo No URL in clipboard
    pause
    exit /b
)

echo Cloning: %url%
git clone --depth=1 "%url%"

if not errorlevel 1 (
    echo Clone successful!
    echo Run `git fetch --unshallow` for full history
) else (
    echo Clone failed!
    pause
)