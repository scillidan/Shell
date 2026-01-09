#Requires AutoHotkey v2.0
; Base on https://github.com/LengxiQwQ/capslock-ime-switcher/tree/main/CapsLock_IME_Switcher_Script_code_Multiple_Versions, the HKL version
; Modified: Only use RShift for IME switching, with CapsLock reset menu
; Authors: DeepSeek🧙‍♂️, scillidan🤡

#SingleInstance Force
; Automatically run as administrator
if not A_IsAdmin
{
    try
    {
        Run "*RunAs `"" A_ScriptFullPath "`""
    }
    catch
    {
        MsgBox "Failed to elevate privileges. Please run the script manually as administrator."
    }
    ExitApp
}
; Configuration parameters
tipLife  := 2000    ; Tip display duration (milliseconds, extended to see HKL value clearly)
checkDelay := 20    ; Delay for detecting failed switch (milliseconds)
; Preload input method layouts (HKL)
CHS_HKL := DllCall("LoadKeyboardLayoutW", "WStr", "00000804", "UInt", 1, "Ptr") ; Chinese (Simplified Pinyin)
ENG_HKL := DllCall("LoadKeyboardLayoutW", "WStr", "00000409", "UInt", 1, "Ptr") ; English (US)

; Create tray menu with reset CapsLock option
CreateTrayMenu() {
    ; Add a separator before our custom menu items
    A_TrayMenu.Add()
    ; Add our custom menu item
    A_TrayMenu.Add("Reset CapsLock to Lowercase", ResetCapsLockState)
}

; Call the function to add our menu item
CreateTrayMenu()

; Right Shift key: switch input method
RShift::
{
    global tipLife, checkDelay, CHS_HKL, ENG_HKL

    ; Short press: perform switch and diagnose HKL value
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if !hwnd
        return
    threadID := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt*", 0)
    currentHKL := DllCall("GetKeyboardLayout", "UInt", threadID, "Ptr")
    targetHKL := (currentHKL = CHS_HKL) ? ENG_HKL : CHS_HKL

    ; 1. Prefer using API to switch
    DllCall("ActivateKeyboardLayout", "Ptr", targetHKL, "UInt", 0)
    Sleep(20)

    ; Initial check
    newHKL := DllCall("GetKeyboardLayout", "UInt", threadID, "Ptr")
    switched := (newHKL = targetHKL)

    ; 2. Fallback check (send Win+Space)
    if (!switched)
    {
        Send("{LWin Down}{Space}{LWin Up}")
        Sleep(checkDelay)
        ; Check HKL again
        newHKL := DllCall("GetKeyboardLayout", "UInt", threadID, "Ptr")
        switched := (newHKL = targetHKL)
    }

    ; ---------- Display the switched HKL value ----------
    tip := GetInputMethodID()
    ; Add a label to indicate if HKL switch was successful
    tipLabel := switched ? "HKL switch successful | ID: " : "HKL switch failed | ID: "
    ShowTipAtMouse(tipLabel . tip, tipLife)

    ; Always turn off CapsLock when switching IME
    SetCapsLockState("Off")
}
return

; Reset CapsLock state to lowercase
ResetCapsLockState(*) {
    SetCapsLockState("Off")
    ShowTipAtMouse("CapsLock reset to lowercase", 1500)
}

; HKL diagnostic function: returns the current active window's HKL hexadecimal value
GetInputMethodID() {
    try {
        hwnd := DllCall("GetForegroundWindow", "Ptr")
        if !hwnd
            return "N/A"
        ; Get the thread ID of the foreground window
        threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0)
        ; Call GetKeyboardLayout to get the HKL pointer value
        hklPtr := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
        ; HKL is a Ptr (pointer/handle). Format as a hexadecimal string.
        return Format("{:X}", hklPtr)
    } catch {
        return "ERROR"
    }
}

; Show tooltip at mouse position
ShowTipAtMouse(text, life := 400) {
    MouseGetPos &mx, &my
    ToolTip text, mx - 55, my - 55
    SetTimer(() => ToolTip(""), -life)
}