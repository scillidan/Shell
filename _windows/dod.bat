:: Purpose: Search for files matching a pattern and open selected files/directories in Directory Opus.
:: Tools: fd, grep, fzf, dopus
:: Usage: file.bat <search_pattern> <directory_path>

@echo off
setlocal

if "%~1" == "" (
    set word=".*"
) else (
    set word=%~1
)

if "%~2" == "" (
    set filepath="./"
) else (
    set filepath=%~2
)

FOR /F "usebackq" %%t IN (`fd -t d -t l %word% -pL %filepath% ^
    ^| grep -iE %word% ^
    ^| fzf`) DO dopus "%CD%\%%t"

endlocal