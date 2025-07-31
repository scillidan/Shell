@echo off

mprocs ^
	"%USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe %DOTFILES_DIR%\.config\_windows_autohotkey\User.ahk" ^
	"%USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe %DOTFILES_DIR%\.config\_windows_autohotkey\keyboard_switch.ahk" ^
	"%USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe %USERPROFILE%\Usr\Source\autohotkey\ahk-keyboard-locker\keyboard-locker.ahk" ^
	"%USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe %USERPROFILE%\Usr\Source\autohotkey\QuickSwitch\QuickSwitch.ahk" ^
	"%USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe %USERPROFILE%\Usr\Source\autohotkey\ShortScript\ShortScript.ahk" ^
	"%USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe \"%USERPROFILE%\Usr\Source\autohotkey\toggle-screen-autohotkey\Toggle screen.ahk\"" ^
	"cd %USERPROFILE%\Usr\Source\autohotkey\vxdesktops.ahk && %USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe vxdesktops.ahk" ^
	"cd %USERPROFILE%\Usr\Source\goldendict\GoldenDictOCR && %USERPROFILE%\Scoop\apps\autohotkey1.1\current\AutoHotkeyU64.exe GoldenDictOCR.ahk"