rem Purpose: Convert font files to WOFF and WOFF2 formats using webify and ttf2woff2.
rem Tools: webify, ttf2woff2
rem Usage: file.bat <input_font_files>

@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo No files were provided. Please select files to convert.
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        set "outputFile1=%%~dpnI.woff"
        set "outputFile2=%%~dpnI.woff2"

        webify --no-eot --no-svg "%%~I" && cat "!outputFile1!" | ttf2woff2 > "!outputFile2!"

        if exist "!outputFile2!" (
            echo Converted "%%~I" to "!outputFile1!" "!outputFile2!"
        ) else (
            echo Failed to convert "%%~I"
        )
    ) else (
        echo File "%%~I" does not exist.
    )
)

endlocal
pause