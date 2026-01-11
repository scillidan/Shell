; Search current clipboard text in GoldenDict
; Authors: DeepSeek🧙‍♂️, scillidan🤡

SearchInGoldenDict(groupName) {
    oldClipboard := ClipboardAll
    Clipboard := ""
    Send, ^c
    ClipWait, 0.5

    if (Clipboard != "") {
        query := Trim(Clipboard)
        Run, goldendict --group-name=%groupName% "%query%"
        Clipboard := ""
        Sleep, 100
    } else {
        MsgBox, Not copied to any text, please select the word to query first.
    }

    Clipboard := oldClipboard
    oldClipboard := ""
}

!z::
    SearchInGoldenDict("default")
    return

!+z::
    SearchInGoldenDict("translate")
    return