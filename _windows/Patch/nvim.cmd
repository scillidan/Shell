@echo off

setlocal

rem Custom user environment variables here
set "XDG_CONFIG_HOME=%USER%\Usr\Data"
set "XDG_DATA_HOME=%USER%\Usr\Data"
%SCOOP%\shims\nvim.exe %*

endlocal