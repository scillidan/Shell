:: Purpose: Convert specified image files to JPEG format and delete original files.
:: Tools: magick
:: Usage: file.bat <input_nojpg_files>

@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo No files were provided. Please select files to convert.
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        set "outputFile=%%~dpnI.jpg"

        magick convert "%%~I" -quality 90 "!outputFile!"

        if exist "!outputFile!" (
            echo Converted "%%~I" to "!outputFile!"
            del "%%~I"
        ) else (
            echo Failed to convert "%%~I"
        )
    ) else (
        echo File "%%~I" does not exist.
    )
)

endlocal