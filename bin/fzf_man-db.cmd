@echo off
REM Search and view man pages using fzf.
REM Dependences: rg, bat, fzf
REM Usage:
REM 1. Get man-*-en.zip from https://github.com/scillidan/share_man-db/releases
REM 2. Decompress to `man/`

setlocal

REM Fill the path to `man/`.
set "MAN_PAGES=%USERHOME%\Usr\Data\man"

set FZF_DEFAULT_COMMAND=rg --files
set FLAG=--layout=reverse --border none --preview-border none --no-scrollbar --no-separator --inline-info
set BIND=--bind "ctrl-k:preview-up,ctrl-j:preview-down,ctrl-h:preview-page-up,ctrl-l:preview-page-down,ctrl-t:toggle-preview"
set BIND_OPEN=--bind "enter:execute(less -RN {+})+abort"
set PREVIEW=--preview "bat -f -p {}"
set PREVIEW_WINDOW=--preview-window "up,80%%,+{2}+3/3,~2"

pushd "%MAN_PAGES%"

fzf %FLAG% %BIND% %BIND_OPEN% %PREVIEW% %PREVIEW_WINDOW%

popd

endlocal
