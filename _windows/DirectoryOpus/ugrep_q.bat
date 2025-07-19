:: Purpose: Open a WezTerm window in a specified directory and run the ugrep command.
:: Tools: wezterm, ugrep
:: Usage: file.bat <directory>

@echo off

wezterm start --cwd %* ugrep -Q