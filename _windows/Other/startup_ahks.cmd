@echo off

setlocal

set AHK=%USERHOME%\Usr\Git\Shell\_windows\autohotkey
set AHK_SRC=%USERHOME%\Usr\Source\autohotkey

start "" autohotkeyu64 "%AHK%\user.ahk"
timeout /t 1 /nobreak >nul
start "" autohotkeyu64 "%AHK%\goldendict_search_in_group.ahk"
timeout /t 1 /nobreak >nul
start "" autohotkeyu64 "%AHK%\select_mod.ahk"
timeout /t 1 /nobreak >nul
start "" autohotkeyu64 "%AHK%\clipboard_mod.ahk"
timeout /t 1 /nobreak >nul
start "" autohotkeyu64 "%AHK_SRC%\Vis2\Vis2.ahk"

endlocal