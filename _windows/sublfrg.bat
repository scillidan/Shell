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

FOR /F "usebackq" %%t IN (
  `rg --files --hidden --follow --glob "!.git" -e %word% %filepath% ^
  ^| fzf -m`
) DO subl %%t

endlocal

