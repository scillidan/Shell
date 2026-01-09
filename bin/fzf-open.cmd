@echo off
setlocal enabledelayedexpansion

if "%~1" == "" goto :end

set "ARG=%~1"
set "EXT=%~x1"

set "EXT=!EXT:.=!.%random%"
set "EXT=!EXT:~0,-5!"

if /i "!EXT!" == "cmd" (
    "%~1"
) else if /i "!EXT!" == "bat" (
    "%~1"
) else if /i "!EXT!" == "ps1" (
    pwsh "%~1"
) else if /i "!EXT!" == "sh" (
    bash "%~1"
) else if /i "!EXT!" == "py" (
    uv run "%~1"
) else (
    execute "%~1"
)

:end
exit /b 0