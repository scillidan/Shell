@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        kiwix-manage %USER%\Usr\Data\kiwix\library.xml add "%%~I"
    ) else (
        echo File "%%~I" does not exist.
    )
)

endlocal
