@echo off
rem --------------------------------------------------------------------------
rem https://github.com/chrisant996/clink-gizmos/issues/19
rem Sample script showing how to integrate ripgrep and fzf on Windows.
rem Ported from https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher
rem --------------------------------------------------------------------------

rem -- Make sure local environment variables do not pollute the shell session.
setlocal

rem -- Use %EDITOR% if defined, otherwise fall back to notepad.exe.
if defined EDITOR set EDITEXE=%EDITOR%
if not defined EDITOR set EDITEXE=notepad.exe

rem -- Flags for invoking rg.exe and bat.exe.
set RGEXE=rg.exe --hidden --follow --glob "!.git" --column --line-number --no-heading --color=always --smart-case
set BATEXE=bat.exe --color=always --style=numbers

rem -- The configuration for launching fzf.
set FLAGS=--ansi --disabled --delimiter :
set BIND_START=--bind "start:reload:%RGEXE% {q}"
set BIND_RELOAD=--bind "change:reload:%RGEXE% {q} || call;"
set BIND_ENTER=--bind "enter:execute({1})+abort"
set BIND_EDIT=--bind "ctrl-e:execute(nvim {1} +{2})+abort"
set BINDS=--bind "ctrl-u:preview-up,ctrl-d:preview-down,alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview"
set PREVIEW=--preview "%BATEXE% {1} --highlight-line {2}"
set PREVIEW_WINDOW=--preview-window "up,60%%,border-bottom,+{2}+3/3,~3"
set QUERY=--query "%*"

rem -- Launch fzf.
fzf.exe %FLAGS% %BIND_START% %BIND_RELOAD% %BIND_ENTER% %BIND_EDIT% %BINDS% %PREVIEW% %PREVIEW_WINDOW% %QUERY%

endlocal