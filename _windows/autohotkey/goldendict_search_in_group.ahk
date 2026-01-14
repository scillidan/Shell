; Search current clipboard text in GoldenDict
; Authors: DeepSeek🧙‍♂️, scillidan🤡

SearchInGoldenDict(groupName) {
    oldClipboard := ClipboardAll
    query := Trim(Clipboard)

    if (query != "") {
        Run, goldendict --group-name=%groupName% "%query%"
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