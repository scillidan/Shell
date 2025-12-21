@echo off

setlocal

rem Custom user environment variables here
set "XDG_CONFIG_HOME=%USER%\Usr\Data"
set "XDG_DATA_HOME=%USER%\Usr\Data"

neovide --size=1250x720 --frame none --no-tabs --neovim-bin nvim.exe %*

endlocal