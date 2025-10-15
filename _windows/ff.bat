@echo off
rem Reference: https://github.com/chrisant996/clink-gizmos/issues/19,
rem https://thevaluable.dev/practical-guide-fzf-example/
rem Purpose: Interactive file and directory finder using fzf with various preview and key bindings.
rem Tools: rg, fd, erd, bat, fzf
rem Usage: file.bat

setlocal

set RG=rg --files --hidden --follow --glob "!.git"
:: set ES=es -match-path "*" -path ./
set FD=fd -t d -t l .* -pL ./
set ERD=erd --color auto --hidden --follow --human --sort name --dir-order first
set BAT=bat --style=numbers --color=always

set FLAG=--multi --walker-skip .github
set FLAG_STYLE=--layout=reverse --border none --preview-border none --no-scrollbar --no-separator --inline-info
set BIND=--bind "ctrl-u:preview-up,ctrl-d:preview-down,alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview"
set BIND_SEARCH_FILE=--bind "alt-f:change-prompt(Files > )+reload(%RG%)+change-preview(%BAT% {})+refresh-preview"
:: set BIND_SEARCH_FILE=--bind "alt-f:change-prompt(Files > )+reload(%ES%)+change-preview()+refresh-preview"
set BIND_SEARCH_DIR=--bind "alt-d:change-prompt(Dirs > )+reload(%FD%)+change-preview(%ERD% {})+refresh-preview"
set BIND_OPEN=--bind "enter:execute({+})+abort"
set BIND_EDIT=--bind "ctrl-e:execute(%EDITOR% {+})+abort"
:: set BIND_EDIT_SUBL=--bind "ctrl-e:execute(subl -a {+})+abort"
:: set BIND_EDIT_VSCODE=--bind "ctrl-e:execute(code -r {+})+abort"
:: set BIND_EDIT_VSCODIUM=--bind "ctrl-e:execute(vscodium -r {+})+abort"
set PREVIEW=--preview "%BAT% {}"
set PREVIEW_WINDOW=--preview-window "right,60%%,wrap"
set QUERY=

fzf %FLAG% %FLAG_STYLE% %BIND% %BIND_SEARCH_FILE% %BIND_SEARCH_DIR% %BIND_OPEN% %BIND_EDIT% %PREVIEW% %PREVIEW_WINDOW% %QUERY%

endlocal