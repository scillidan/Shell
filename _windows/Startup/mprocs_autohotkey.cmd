@echo off

mprocs ^
	"autohotkeyu64 %DOTFILES_DIR%\.config\_windows_autohotkey\User.ahk" ^
	"autohotkeyu64 %DOTFILES_DIR%\.config\_windows_autohotkey\keyboard_autoswitch.ahk" ^
	"autohotkeyu64 %USERHOME%\Usr\Source\autohotkey\ahk-keyboard-locker\keyboard-locker.ahk" ^
	"autohotkeyu64 %USERHOME%\Usr\Source\autohotkey\QuickSwitch\QuickSwitch.ahk" ^
	"autohotkeyu64 %USERHOME%\Usr\Source\autohotkey\ShortScript\ShortScript.ahk" ^
	"autohotkeyu64 %USERHOME%\Usr\Source\autohotkey\Vis2\demo_user.ahk" ^
	"autohotkeyu64 \"%USERHOME%\Usr\Source\autohotkey\toggle-screen-autohotkey\Toggle screen.ahk\"" ^
	"cd %USERHOME%\Usr\Source\goldendict\GoldenDictOCR && autohotkeyu64 GoldenDictOCR.ahk"