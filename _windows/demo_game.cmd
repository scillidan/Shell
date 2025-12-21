@echo off
setlocal

rem Check the first argument passed to the script.
if "%~1"=="" (
    echo Usage: game.cmd [on|off]
    exit /b 1
)

if /i "%~1"=="on" (
    echo Turning game mode ON. Closing applications...
    rem Opt that will do makelink for it .lnk on Startup\
    start taskkill /IM "ollama app.exe"
    start taskkill /IM "CenterTaskbar.exe"
    start taskkill /IM "deskpins.exe"
    start taskkill /IM "Ditto.exe"
    start taskkill /IM "dnGREP.exe"
    start taskkill /IM "EarTrumpet.exe"
    start taskkill /IM "espansod.exe"
    start taskkill /IM "GoldenDict.exe"
    start taskkill /IM "keypirinha-x64.exe"
    start taskkill /IM "RBTray.exe"
    start taskkill /IM "RectangleWin-x64.exe"
    start taskkill /IM "ReduceMemory.exe"
    start taskkill /IM "sizer.exe"
    start taskkill /IM "Clock64.exe"
    start taskkill /IM "zeal.exe"
    rem ---
    start taskkill /IM "resizer2-portable.exe"
    start taskkill /IM "AutoHotkeyU64.exe"
    start taskkill /IM "Snipaste.exe"
    start taskkill /IM "clash-verge.exe"
    rem Opt that set it run at startup
    start taskkill /IM "AltBacktick.exe"
    start taskkill /IM "everything.exe"
    start taskkill /IM "Magpie.exe"
    start taskkill /IM "qbittorrent.exe"
    start taskkill /IM "tailscale-ipn.exe"
    echo Game mode ON. Applications have been closed.
    exit /b 0
)

if /i "%~1"=="off" (
    echo Turning game mode OFF. Restarting applications...
    rem Opt that will do makelink for it .lnk on Startup\
    start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Ollama.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\CenterTaskbar.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\DeskPins.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Ditto.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\dnGREP.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\EarTrumpet.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Espanso.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\GoldenDict.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Keypirinha.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\RBTray.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\RectangleWin.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Reduce Memory.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Sizer.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\T-Clock.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Tailscale.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Zeal.lnk"
    rem ---
    start %USER%\Scoop\shims\resizer2.exe"
    start %USER%\Usr\Git\Shell\_windows\Startup\mprocs_autohotkey.cmd"
    start %LOCALAPPDATA"%\Microsoft\WindowsApps\Snipaste.exe"
    start %ProgramFiles"%\Clash Verge\clash-verge.exe"
    rem Opt that set it run at startup
    start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\AltBacktick.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Everything.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Magpie.lnk"
    start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\qBittorrent Enhanced Edition.lnk"
	start %APPDATA%\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Tailscale.lnk"
    echo Game mode OFF. Applications have been restarted.
    exit /b 0
)

echo Invalid argument: %~1. Use 'on' or 'off'.
exit /b 1