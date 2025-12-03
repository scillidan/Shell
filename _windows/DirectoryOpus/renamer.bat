@echo off
@rem Purpose: Rename files using gsudo in a specified directory with the nv editor.
@rem Tools: gsudo, node, renamer
@rem Usage: file.bat <directory>

setlocal

set RENAME_EDITOR=nvim
gsudo rn.CMD --base %*

endlocal