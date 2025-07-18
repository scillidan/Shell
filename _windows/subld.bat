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
  ^| fzf`) DO subl %%t

endlocal