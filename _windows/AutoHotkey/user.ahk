#NoEnv
SetWorkingDir %A_ScriptDir%

^!+?::Run wezterm-gui start bash ugrep_files.sh cheatsheet
^!+k::Run wezterm-gui start bash ugrep_files.sh shortcut
^!+o::Run wezterm-gui start mineru_imgs --lang ch

^!+c::
    Send, ^c
    Sleep, 100
    Run, wezterm-gui start bash _pylanguagetool.sh --api-url "http://ubuntu22:8040/v2/"
    return