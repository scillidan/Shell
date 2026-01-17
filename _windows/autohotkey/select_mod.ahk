#Persistent
mode := false
targetExe := ""

; Ctrl+Alt+g
^!g::
	mode := !mode
	if (mode) {
		MouseGetPos, , , winId
		if (winId) {
			WinGet, targetExe, ProcessName, ahk_id %winId%
			ToolTip, Select watching ON for %targetExe%
		} else {
			ToolTip, Select watching ON but no window under mouse
			mode := false
		}
	} else {
		ToolTip, Select watching OFF
	}
	SetTimer, RemoveToolTip, -1000
return

; Hotkey to copy selected text when mode is on
~LButton Up::
	if (mode) {
		; Get the current active window's executable
		WinGet, currentExe, ProcessName, A
		if (currentExe = targetExe) {
			; Store the current clipboard content
			oldClipboard := clipboard
			; Copy selected text to clipboard
			Send, ^c
			; Small delay to allow clipboard to update
			Sleep, 50
			; Check if the clipboard content has changed
			if (clipboard != oldClipboard) {
				ToolTip, Copied to clipboard
			} else {
				; Restore the old clipboard content
				clipboard := oldClipboard
			}
			SetTimer, RemoveToolTip, -1000
		}
	}
return

RemoveToolTip:
	ToolTip
return
