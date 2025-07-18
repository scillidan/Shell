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

FOR /F "usebackq" %%t IN (`fd -t f -t l %word% -pL %filepath% ^
  ^| fzf -m`) DO dopus "%CD%\%%t"

endlocal