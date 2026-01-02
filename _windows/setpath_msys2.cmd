@echo off

SETLOCAL EnableDelayedExpansion

set "action=%~1"

set "paths_to_add=C:\msys64\mingw64\bin;C:\msys64\usr\bin;C:\msys64\usr\lib;C:\msys64\mingw64\lib;C:\msys64\usr\include;C:\msys64\mingw64\include"

if "%action%" == "on" (
    echo Adding paths to PATH...
    set "new_path=%PATH%;%paths_to_add%"
    setx PATH "%new_path%"
    echo Please restart your command prompt for changes to take effect.
) else if "%action%" == "off" (
    echo Removing paths from PATH...
    set "new_path="
    for %%p in ("%PATH:;=" "%") do (
        set "current=%%~p"
        echo !current! | findstr /i /v /c:"C:\msys64" >nul
        if !errorlevel! equ 0 (
            if "!new_path!" == "" (
                set "new_path=!current!"
            ) else (
                set "new_path=!new_path!;!current!"
            )
        )
    )
    setx PATH "!new_path!"
    echo Please restart your command prompt for changes to take effect.
) else (
    echo Usage: %~nx0 on^|off
)

endlocal
