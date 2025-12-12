@echo off
@rem Purpose: Optimize PNG files using oxipng.
@rem Tools: oxipng
@rem Usage: file.bat <pngs>

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo No files were provided. Please select files to convert.
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        oxipng -o 4 -i 1 --strip safe "%%~I"
    ) else (
        echo File "%%~I" does not exist.
    )
)

endlocal