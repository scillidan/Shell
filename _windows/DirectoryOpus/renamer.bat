:: Purpose: Rename files using gsudo in a specified directory with the nv editor.
:: Tools: gsudo, node, renamer
:: Usage: file.bat <directory>

@echo off

setlocal

set RENAME_EDITOR=nvim
gsudo rn.CMD --base %*

endlocal