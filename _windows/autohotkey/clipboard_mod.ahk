#Persistent
mode := false
lastClipboard := ""
targetExe := ""

^!+g::
	mode := !mode
	if (mode) {
		MouseGetPos, , , winId
		if (winId) {
			WinGet, targetExe, ProcessName, ahk_id %winId%
			ToolTip, Clipboard watching ON for %targetExe%
			SetTimer, WatchClipboard, 100
		} else {
			ToolTip, Clipboard watching ON but no window under mouse
			mode := false
		}
	} else {
		ToolTip, Clipboard watching OFF
		SetTimer, WatchClipboard, Off
		targetExe := ""
	}
	SetTimer, RemoveToolTip, -1000
return

WatchClipboard:
	if (mode) {
		MouseGetPos, , , currentWinId, 2
		WinGet, currentWinProcessName, ProcessName, ahk_id %currentWinId%
		if (currentWinProcessName = targetExe) {
			currentClipboard := clipboard
			if (currentClipboard != lastClipboard) {
				Run, goldendict --popup-group-name=default "%currentClipboard%"
				lastClipboard := currentClipboard
				clipboard := ""
			}
		}
	}
return

RemoveToolTip:
	ToolTip
return
