@echo off
cd /d "%~dp0"
pwsh -ExecutionPolicy Bypass -File "startup_shortcuts.ps1"
pause