@echo off
REM Convert PGS files to SRT format
REM Dependence:
REM scoop install https://github.com/scillidan/scoop-bucket/blob/master/bucket/pgstosrt.json
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <sup1> <sup2> ...

setlocal enabledelayedexpansion

set "tessdata=%USERPROFILE%\Usr\Model\tessdata_fast"

for %%I in (%*) do (
    set "outputFile=%%~dpnI.srt"
    pgstosrt --input "%%~I" --output "!outputFile!" --tesseractlanguage eng --tesseractdata "!tessdata!"
)

endlocal