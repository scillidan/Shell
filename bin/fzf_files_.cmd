@echo off
REM Search and view man pages using fzf.
REM Dependences: rg, bat, fzf

setlocal

REM 1. Get man-*-en.zip from https://github.com/scillidan/share_man-db/releases
REM 2. Decompress to `man/`
if not defined MAN_PAGES set "MAN_PAGES=%USERHOME%\Usr\Data\man"
REM scoop install tldr
REM tldr -u
if not defined TLDR_PAGES set "TLDR_PAGES=%APPDATA%\tldr\pages"

set FZF_DEFAULT_COMMAND=rg --files
set FLAG=--layout=reverse --border none --preview-border none --no-scrollbar --no-separator --inline-info
set BIND=--bind "ctrl-k:preview-up,ctrl-j:preview-down,ctrl-h:preview-page-up,ctrl-l:preview-page-down,ctrl-t:toggle-preview"
set BIND_OPEN=--bind "enter:execute(less -RN {+})+abort"
set PREVIEW=--preview "bat -f -p {}"
set PREVIEW_WINDOW=--preview-window "up,80%%,+{2}+3/3,~2"

if "%1"=="" (
    echo Usage: fzf_files_ [man^|tldr]
    exit /b 1
)

if /i "%1"=="man" (
    if not exist "%MAN_PAGES%" (
        echo MAN_PAGES directory not found: "%MAN_PAGES%"
        echo Please set MAN_PAGES variable or update the path in the script
        exit /b 1
    )
    pushd "%MAN_PAGES%"
    fzf %FLAG% %BIND% %BIND_OPEN% %PREVIEW% %PREVIEW_WINDOW%
    popd
) else if /i "%1"=="tldr" (
    if not exist "%TLDR_PAGES%" (
        echo TLDR_PAGES directory not found: "%TLDR_PAGES%"
        echo Please set TLDR_PAGES variable or update the path in the script
        exit /b 1
    )
    pushd "%TLDR_PAGES%"
    fzf %FLAG% %BIND% %BIND_OPEN% %PREVIEW% %PREVIEW_WINDOW%
    popd
) else (
    echo Invalid argument: %1
    echo Usage: fzf_files_ [man^|tldr]
    exit /b 1
)

endlocal