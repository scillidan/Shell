:: Purpose: Rename files in a specified directory using gsudo with nvim as the editor.
:: Tools: gsudo, pipe-rename
:: Usage: file.bat <directory>

@echo off

cd %*
gsudo renamer --editor "nvim" *