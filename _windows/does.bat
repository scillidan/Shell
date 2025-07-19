:: Purpose: Search for files and directories using a matching path and open selected items in Directory Opus.
:: Tools: es, grep, fzf, dopus
:: Usage: file.bat <search_pattern> <directory_path>

@echo off
setlocal

if "%~1" == "" (
    set word=""
) else (
    set word=%~1
)

if "%~2" == "" (
    set filepath="./"
) else (
    set filepath=%~2
)

FOR /F "usebackq" %%t IN (`es -match-path %word% -path %filepath% ^
    ^| grep -iE %word% ^
    ^| fzf`) DO dopus "%CD%\%%t"

endlocal