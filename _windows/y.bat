:: Purpose: Run yazi.exe with all arguments and change directory based on yazi's output.
:: Tools: yazi.exe
:: Usage: y.bat <arguments>

@echo off

set "tmpfile=%TEMP%\yazi-cwd.tmp"

yazi %* --cwd-file=%tmpfile%

set "cwd="
set /p cwd=<"%tmpfile%"

if defined cwd (
    for /f "delims=" %%i in ('cd') do set "CURRENT_DIR=%%i"
    if /i not "%cwd%"=="%CURRENT_DIR%" (
        cd /d "%cwd%"
    )
)

del /f /q "%tmpfile%"