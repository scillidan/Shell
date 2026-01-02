#NoEnv
SetWorkingDir %A_ScriptDir%
^!+c::Run wezterm start bash venv_pylanguagetool.sh --api-url "http://ubuntu22:8040/v2/"
^!+?::Run wezterm start bash ugrep_files.sh cheatsheet
^!+k::Run wezterm start bash ugrep_files.sh shortcut
^!+o::Run wezterm start mineru_imgs --lang ch
