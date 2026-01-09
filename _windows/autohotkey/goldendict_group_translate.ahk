; Search current clipboard text in GoldenDict, the `translate` group.
; Authors: DeepSeek🧙‍♂️, scillidan🤡

!+z::
    ; Backup original clipboard content
    oldClipboard := ClipboardAll

    ; Get current clipboard text
    Clipboard := ""
    Send, ^c
    ClipWait, 0.5

    ; If clipboard has content, call GoldenDict
    if (Clipboard != "") {
        ; Remove line breaks and extra spaces
        query := Trim(Clipboard)

        ; Call GoldenDict
        Run, goldendict.exe --popup-group-name=translate "%query%"

        ; Clear clipboard
        Clipboard := ""

        ; Short delay to ensure GoldenDict window gets focus
        Sleep, 100
    }

    ; Restore original clipboard content
    Clipboard := oldClipboard
    ; Free memory
    oldClipboard := ""

    return