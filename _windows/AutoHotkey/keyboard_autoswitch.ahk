; Automatically switch the keyboard layout to the English (United States) layout when a user activates a new window.
; Authors: perplexity.ai🧙‍♂️, scillidan🤡
; Usage: autohotkeyu64.exe script.ahk

; Delay (milliseconds) after switching to a new window
SwitchDelay := 300
; EN‑US layout code (0x0409)
EN_Code := 0x409

lastWinID := 0

#Persistent
SetTimer, CheckActiveWindow, 100
return

CheckActiveWindow:
    global lastWinID, SwitchDelay

    WinGet, thisID, ID, A
    if (thisID = "")
        return

    if (thisID != lastWinID) {
        lastWinID := thisID
        ; delayed check for this new window
        SetTimer, EnsureEnglishLayout, % "-" . SwitchDelay
    }
return

EnsureEnglishLayout:
    global lastWinID, EN_Code

    ; Confirm window is still active
    WinGet, curID, ID, A
    if (curID != lastWinID)
        return

    ; Get current keyboard layout of active thread
    threadID := DllCall("GetWindowThreadProcessId", "UInt", curID, "UInt", 0)
    curLayout := DllCall("GetKeyboardLayout", "UInt", threadID, "UInt")

    ; Low word is language ID
    langID := curLayout & 0xFFFF

    ; If not EN‑US, switch to EN‑US
    if (langID != EN_Code) {
        PostMessage, 0x50, 0, EN_Code,, ahk_id %curID%
    }
return
