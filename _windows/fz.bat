:: Purpose: Launch an interactive file finder using fzf with rg as the default command.
:: Tools: fzf, rg
:: Usage: file.bat

@echo off

setlocal

set FZF_DEFAULT_COMMAND=rg --files --hidden --follow --glob "!.git"
set FZF_DEFAULT_OPTS=--color=dark --height ~100% --layout=reverse --inline-info --preview "bat -n --theme=base16-256 --color=always {}" --walker-skip .github

fzf %*

endlocal