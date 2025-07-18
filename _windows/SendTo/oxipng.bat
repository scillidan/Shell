:: Purpose: Optimize PNG files using oxipng.
:: Tools: oxipng
:: Usage: file.bat <input_png_files>

@echo off
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