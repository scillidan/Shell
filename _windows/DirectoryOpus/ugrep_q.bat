rem Purpose: Open a WezTerm window in a specified directory and run the ugrep command.
rem Tools: wezterm, ugrep
rem Usage: file.bat <directory>

@echo off

wezterm start --cwd %* ugrep -Q