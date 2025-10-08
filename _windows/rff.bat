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
  ^| fzf --color=dark --height ~100% --layout=reverse --inline-info --preview "bat -n --theme=base16-256 --color=always {}" --walker-skip .github -m`
) DO nvim %%t

endlocal

