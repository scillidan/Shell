:: Purpose: Start a local server and open a web page in the default browser.
:: Tools: node
:: Usage: file.bat <directory>

@echo off

cd %*
brave http://localhost:4323
serve.CMD . -p 4323