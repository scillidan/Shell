@echo off
@rem Purpose: Start a local server and open a web page in the default browser.
@rem Tools: node
@rem Usage: file.bat <directory>

cd %*
brave http://localhost:4323
serve.CMD . -p 4323