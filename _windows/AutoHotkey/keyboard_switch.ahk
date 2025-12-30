; Switch between two keyboard layouts—English (US) and Chinese (Simplified, PRC)—using the Caps Lock key.
; Base on https://github.com/xmdn/2_of_3_lang_switch_hotkey
; Usage:
; 1. Windows 10 → Advanced keyboard settings → Input language hot keys → Advanced key settings
; 1.1 Set Alt+Shift+0 to switch to English
; 1.2 Set Alt+Shift+1 to switch to Chinese
; 2. autohotkeyu64.exe script.ahk
; 3. Type <Tab> to switch keyboard

; English (United States)
englishLayout := "00000409"
; Chinese (Simplified, PRC)
chineseLayout := "00000804"

SetKeyboardLayoutShortcut(shortcut) {
	SendInput, {Alt down}{Shift down}%shortcut%{Shift up}{Alt up}
}

CapsLock::
	currentLayout := GetKeyboardLayout()

	if (currentLayout = englishLayout) {
		SetKeyboardLayoutShortcut("1")
	} else if (currentLayout = chineseLayout) {
		SetKeyboardLayoutShortcut("0")
	} else {
		SetKeyboardLayoutShortcut("0")
	}
return

GetKeyboardLayout() {
	hwnd := WinExist("A")
	threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt", 0)
	langId := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
	return Format("{:08x}", langId & 0xFFFF)
}
