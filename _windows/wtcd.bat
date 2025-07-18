:: Purpose: Launch Wezterm GUI in the provided directory or file path.
:: Tools: Wezterm
:: Usage: file.bat <directory_or_file_path>

@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Please provide a directory or file path as input.
    exit /b 1
)

set "input=%~1"
echo Input provided: "%input%"

if exist "%input%\" (
    echo Input is a directory.
    start "" "C:\Users\User\Scoop\apps\wezterm\current\wezterm-gui.exe" start --cwd "%input%"
    exit /b 0
)

if exist "%input%" (
    echo Input is a file.

    for %%F in ("%input%") do (
        set "dir=%%~dpF"
        set "dir=!dir:~0,-1!"
        echo Retrieved directory: "!dir!"
    )

    if "!dir!"=="" (
        echo Failed to retrieve directory. Please check the input path.
        exit /b 1
    )

    start "" "C:\Users\User\Scoop\apps\wezterm\current\wezterm-gui.exe" start --cwd "!dir!"
    exit /b 0
)

echo The specified input does not exist.
exit /b 1