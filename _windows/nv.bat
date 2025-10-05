@echo off

setlocal

set "XDG_CONFIG_HOME=%LOCALAPPDATA%"
set "XDG_DATA_HOME=%LOCALAPPDATA%"

neovide --size=1250x720 --frame none --no-tabs --neovim-bin nvim.exe %*

endlocal