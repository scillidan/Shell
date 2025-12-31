@echo off

setlocal

rem Custom user environment variables here
set "XDG_CONFIG_HOME=%USERHOME%\Usr\Data"
set "XDG_DATA_HOME=%USERHOME%\Usr\Data"
%SCOOP%\shims\nvim.exe %*

endlocal