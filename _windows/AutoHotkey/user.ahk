#NoEnv
SetWorkingDir %A_ScriptDir%

^!+?::Run wezterm-gui start bash ugrep_files.sh cheatsheet

^!+c::
    Send, ^c
    Sleep, 100
    Run, wezterm-gui start bash _pylanguagetool.sh --api-url "http://localhost:8040/v2/"
    return