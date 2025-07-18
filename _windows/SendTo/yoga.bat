:: Purpose: Resize images using Yoga and delete the original files after conversion.
:: Tools: yoga
:: Usage: file.bat <input_image_files>

@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo No files were provided. Please select files to convert.
    exit /b
)

for %%I in (%*) do (
    if exist "%%~I" (
        set "outputFile=%%~dpI_yoga_%%~nI.png"

        yoga image --resize 1920 "%%~I" "!outputFile!"

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