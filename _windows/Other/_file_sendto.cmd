@echo off
REM Example
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select file > Context Menu > SendTo > script.bat
REM 2. Drag and drop file onto this script
REM 3. script.cmd <file>

pushd <workdir>

<bin> "%~1"

popd