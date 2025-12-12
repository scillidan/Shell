@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        kiwix-serve --address 0.0.0.0 --port 5173 "%%~I"
    ) else (
        echo File "%%~I" does not exist.
    )
)

endlocal
