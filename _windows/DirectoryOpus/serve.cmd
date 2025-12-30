@echo off
REM Start a local server and open a web page in the default browser.
REM Dependences: nodejs, serve, open-cli
REM Usage: script.cmd <dir>

pushd %*

wezterm start serve.CMD . -p 4323

popd