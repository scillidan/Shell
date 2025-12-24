@echo off
REM Add multiple ZIM files to Kiwix library
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <zim1> <zim2> ...

if "%~1"=="" (
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        kiwix-manage %USER%\Usr\Data\kiwix\library.xml add "%%~I"
    )
)