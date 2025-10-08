@echo off

if "%~1" == "" (
  set word=".*"
) else (
  set word=%~1
)

rem FOR /F "usebackq" %%t IN (`fd -t f -t l %word% -pL ^
FOR /F "usebackq" %%t IN (`rg --files --hidden --follow --glob "!.git" -e %word% . ^
  ^| fzf -m`) DO nvim %%t
