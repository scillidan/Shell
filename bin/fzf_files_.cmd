@echo off
REM Search and view man pages using fzf.
REM Dependences: rg, bat, fzf

setlocal

REM 1. Get man-*-en.zip from https://github.com/scillidan/share_man-db/releases
REM 2. Decompress to `man/`
set "MAN_PAGES=%USERHOME%\Usr\Document\man"
REM scoop install tldr
REM tldr -u
set "TLDR_PAGES=%APPDATA%\tldr\pages"
set "TLDR_PAGES=%APPDATA%\tldr\pages"
REM cargo install dedoc
REM dedoc fetch
REM dedoc ls
REM dedoc download <all_the_ls>
set "DEVDOCS_DOCS=%USERHOME%\Usr\Document\devdocs-user-md"
set "TYPST_DOCS=%USERHOME%\Usr\Document\typst-docs-md"

set FZF_DEFAULT_COMMAND=rg --files
set FLAG=--layout=reverse --border none --preview-border none --no-scrollbar --no-separator --inline-info
set BIND=--bind "ctrl-k:preview-up,ctrl-j:preview-down,ctrl-h:preview-page-up,ctrl-l:preview-page-down,ctrl-t:toggle-preview"
set BIND_OPEN=--bind "enter:execute(less -RN {+})+abort"
set BIND_VIEW=--bind "ctrl+e:execute(dawn {+})+abort"
set PREVIEW=--preview "bat -f -p {}"
set PREVIEW_WINDOW=--preview-window "up,80%%,+{2}+3/3,~2"

set FZF=fzf %FLAG% %BIND% %BIND_OPEN% %BIND_VIEW% %PREVIEW% %PREVIEW_WINDOW%

if /i "%1"=="man" (
    pushd "%MAN_PAGES%"
    %FZF%
    popd
) else if /i "%1"=="tldr" (
    pushd "%TLDR_PAGES%"
    %FZF%
    popd
) else if /i "%1"=="devdocs" (
    pushd "%DEVDOCS_DOCS%"
    %FZF%
    popd
) else if /i "%1"=="typst" (
    pushd "%TYPST_DOCS%"
    %FZF%
    popd
) else (
    echo Invalid argument: %1
    echo Usage: fzf_files_ [man^|tldr^|devdocs]
    exit /b 1
)

endlocal