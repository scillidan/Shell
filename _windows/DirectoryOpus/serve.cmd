@echo off
REM Start a local server and open a web page in the default browser.
REM Dependences: nodejs, serve, open-cli
REM Usage: script.cmd <directory>

cd %*
open-cli http://localhost:4323
serve.CMD . -p 4323