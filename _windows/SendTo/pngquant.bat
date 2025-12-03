@echo off
@rem Purpose: Optimize PNG files using pngquant.
@rem Tools: pngquant
@rem Usage: file.bat <input_png_files>

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo No files were provided. Please select files to convert.
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        pngquant --force --verbose --ordered --speed=1 --quality=85 "%%~I"
    ) else (
        echo File "%%~I" does not exist.
    )
)

endlocal