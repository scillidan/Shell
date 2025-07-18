@echo off
setlocal

if "%~1" == "" (
  set word=".*"
) else (
  set word=%~1
)

set "filepath=C:\Users\User\Usr\Git\cheat C:\Users\User\Usr\Git\Shell"

FOR /F "usebackq" %%t IN (
  `rg --files --hidden --follow --glob "!.git" --glob "*.md" -e %word% %filepath% ^
  ^| fzf -m`
) DO subl %%t

endlocal