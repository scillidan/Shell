REM Scan files and dirs with ClamAV.
REM Authors: GPT-4o mini🧙‍♂️, scillidan🤡
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files or dirs > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <file1> <file2> ... <dir1> <dir2> ...

if exist "%~1\" (
    echo Scanning folder: %~1
    clamscan -r -i "%~1"
) else (
    echo Scanning file: %~1
    clamscan -v -a --max-filesize=1000M --max-scansize=1000M --alert-exceeds-max=yes "%~1"
)

pause