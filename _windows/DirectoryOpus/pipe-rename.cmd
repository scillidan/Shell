@echo off
REM Rename files in a specified directory using gsudo with nvim as the editor.
REM Dependence: gsudo, pipe-rename
REM Usage: script.cmd <directory>

pushd %*

gsudo renamer --editor "nvim" *

popd