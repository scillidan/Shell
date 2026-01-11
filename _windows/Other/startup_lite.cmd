start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\Ditto.lnk"
timeout /t 1 /nobreak >nul
start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\Espanso.lnk"
timeout /t 1 /nobreak >nul
start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\GoldenDict.lnk"
timeout /t 1 /nobreak >nul
start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\Keypirinha.lnk"
timeout /t 1 /nobreak >nul
start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\RectangleWin.lnk"
timeout /t 1 /nobreak >nul
start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\resizer2.lnk"
timeout /t 1 /nobreak >nul
start "" "%USERHOME%\Usr\Data\StartMenu\Scoop Apps\Virtual Desktop Manager.lnk"
timeout /t 2 /nobreak >nul
start "" pwsh -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%USERHOME%\Usr\Git\Shell\_windows\Other\uncap_swap_capslock_esc.ps1"
timeout /t 2 /nobreak >nul
start "" "%SCOOP%\apps\autohotkey\current\v2\AutoHotkey64.exe" "%USERHOME%\Usr\Git\Shell\_windows\autohotkey2\ime-switcher-rshift.ahk"