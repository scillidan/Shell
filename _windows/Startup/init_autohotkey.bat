@echo off
rem Custom user environment variables here.
rem And %SCOOP%\apps\autohotkey1.1\current\autohotkeyu64.exe.

mprocs ^
	"autohotkeyu64 %DOTFILES_DIR%\.config\_windows_autohotkey\User.ahk" ^
	"autohotkeyu64 %DOTFILES_DIR%\.config\_windows_autohotkey\keyboard_switch.ahk" ^
	"autohotkeyu64 %USER%\Usr\Source\autohotkey\ahk-keyboard-locker\keyboard-locker.ahk" ^
	"autohotkeyu64 %USER%\Usr\Source\autohotkey\QuickSwitch\QuickSwitch.ahk" ^
	"autohotkeyu64 %USER%\Usr\Source\autohotkey\ShortScript\ShortScript.ahk" ^
	"autohotkeyu64 %USER%\Usr\Source\autohotkey\Vis2\demo_user.ahk" ^
	"autohotkeyu64 \"%USER%\Usr\Source\autohotkey\toggle-screen-autohotkey\Toggle screen.ahk\"" ^
	"cd %USER%\Usr\Source\autohotkey\vxdesktops.ahk && autohotkeyu64 vxdesktops.ahk" ^
	"cd %USER%\Usr\Source\goldendict\GoldenDictOCR && autohotkeyu64 GoldenDictOCR.ahk"