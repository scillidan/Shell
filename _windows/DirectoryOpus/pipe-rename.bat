rem Purpose: Rename files in a specified directory using gsudo with nvim as the editor.
rem Tools: gsudo, pipe-rename
rem Usage: file.bat <directory>

@echo off

cd %*
gsudo renamer --editor "nvim" *