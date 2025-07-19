:: Purpose: Clone a Git repository from a URL copied to the clipboard using Alacritty terminal.
:: Tools: powershell, alacritty, git
:: Usage: file.bat <directory>

@echo off
setlocal EnableDelayedExpansion

for /f "usebackq delims=" %%G in (`powershell -command "Get-Clipboard"`) do set "url=%%G"

cd %* || exit /b
C:\Users\User\Scoop\shims\git.exe clone --depth=1 %url%

if %errorlevel% equ 0 (
    echo Clone successful!
    echo Run `git fetch --unshallow` to converts a shallow clone into a complete clone.
) else (
    echo Clone failed!
)

pause
endlocal