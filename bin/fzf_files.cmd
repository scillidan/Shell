@echo off
REM Interactive file and directory finder using fzf with preview and key bindings.
REM Dependences: fd, dir, bat, fzf
REM Optionals: rg, everything-cli(es), dirx, eza ...
REM References:
REM - https://github.com/chrisant996/clink-gizmos/issues/19
REM - https://thevaluable.dev/practical-guide-fzf-example
REM - https://github.com/narnaud/clink-terminal/blob/main/scripts/fzf-preview.cmd
REM PS:
REM After switching modes, the sorting of Files mode will change. I don't know why.

setlocal

REM Optionals
set FD=fd -t l -p -E ".git" -E ".venv" -E "__pycache__" -E "node_modules" -E "public" -E "site"
set RG=rg --files --hidden --follow --glob "!.git" --glob "!.venv" --glob "!__pycache__" --glob "!node_modules" --glob "!public" --glob "!site"
set ES=es -match-path "*" -path .

set DIR=dir /b /a-d /o:n /s
set DIRX=dirx /b /X:d /a:-s-h --bare-relative --level=3 --tree --icons=always --escape-codes=always --utf8 --ignore-glob=.git/**
set EZA=eza --tree --icons --classify --group-directories-first --git
set ERD=erd --layout inverted --color auto --human --sort name --dir-order first --hidden --follow

set BAT=bat --force-colorization --style=numbers,changes --line-range=:500
REM
set PREVIEW_SCRIPT=fzf-preview.cmd

set SEARCH_FILE=%FD% -t f
set SEARCH_DIR=%FD% -t d
set PREVIEW_FILE=%PREVIEW_SCRIPT%
set REVIEW_DIR=%DIRX%

REM fzf
set FZF_DEFAULT_COMMAND=%SEARCH_FILE%
set FLAG=--multi
set FLAG_STYLE=--layout=reverse --border none --preview-border none --no-scrollbar --no-separator --inline-info
set BIND=--bind "ctrl-k:preview-up,ctrl-j:preview-down,ctrl-h:preview-page-up,ctrl-l:preview-page-down,ctrl-t:toggle-preview"
set BIND_SEARCH_FILE=--bind "alt-f:change-prompt(Files > )+reload(%SEARCH_FILE%)+change-preview(%PREVIEW_FILE% {})+refresh-preview"
set BIND_SEARCH_DIR=--bind "alt-d:change-prompt(Dirs > )+reload(%SEARCH_DIR%)+change-preview(%REVIEW_DIR% {})+refresh-preview"
set BIND_OPEN=--bind "enter:execute({+})+abort"
set BIND_EDIT=--bind "ctrl-e:execute(%EDITOR% {+})+abort"
rem set BIND_EDIT_NVIM=--bind "ctrl-e:execute(nvim {+})+abort"
rem set BIND_EDIT_SUBL=--bind "ctrl-e:execute(subl -a {+})+abort"
rem set BIND_EDIT_VSCODE=--bind "ctrl-e:execute(code -r {+})+abort"
rem set BIND_EDIT_VSCODIUM=--bind "ctrl-e:execute(vscodium -r {+})+abort"
set PREVIEW=--preview "%PREVIEW_FILE% {}"
set PREVIEW_WINDOW=--preview-window "right,60%%,wrap,~2"

fzf %FLAG% %FLAG_STYLE% %BIND% %BIND_SEARCH_FILE% %BIND_SEARCH_DIR% %BIND_OPEN% %BIND_EDIT% %PREVIEW% %PREVIEW_WINDOW%

endlocal