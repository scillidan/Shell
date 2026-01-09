; Search current clipboard text in GoldenDict
; Authors: DeepSeek🧙‍♂️, scillidan🤡

!z::
    oldClipboard := ClipboardAll
    Clipboard := ""
    Send, ^c
    ClipWait, 0.5
    if (Clipboard != "") {
        query := Trim(Clipboard)
        ; Search in dictionary group
        Run, goldendict --popup-group-name=default "%query%"
        Clipboard := ""
        Sleep, 100
    }
    Clipboard := oldClipboard
    oldClipboard := ""
    return

!+z::
    oldClipboard := ClipboardAll
    Clipboard := ""
    Send, ^c
    ClipWait, 0.5
    if (Clipboard != "") {
        query := Trim(Clipboard)
        ; Search in translate group
        Run, goldendict --popup-group-name=translate "%query%"
        Clipboard := ""
        Sleep, 100
    }
    Clipboard := oldClipboard
    oldClipboard := ""
    return