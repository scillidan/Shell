:: Purpose: Extract audio from video files and convert it to M4B format.
:: Tools: ffmpeg
:: Usage: file.bat [-d <output_directory>]

@echo off
setlocal enabledelayedexpansion

set "outputDir="
if "%~1"=="-d" (
    set "outputDir=%~2"
    if not exist "!outputDir!" (
        echo Output directory does not exist: !outputDir!
        echo Creating directory...
        mkdir "!outputDir!"
    )
)

if not defined outputDir (
    set "outputDir=%cd%"
)

for %%f in (*.mp4 *.webm) do (
    set "baseName=%%~nf"
    echo Processing "%%f"...

    ffmpeg -i "%%f" -vn -acodec flac "!outputDir!\!baseName!.flac"
    if errorlevel 1 (
        echo Failed to extract audio from "%%f"
        exit /b 1
    )

    ffmpeg -i "!outputDir!\!baseName!.flac" -c:a aac -b:a 128k -minrate 64k -maxrate 192k -ar 44100 "!outputDir!\!baseName!.m4b"
    if errorlevel 1 (
        echo Failed to convert "!outputDir!\!baseName!.flac" to M4B
        exit /b 1
    )

    del "!outputDir!\!baseName!.flac"
)

echo All files processed.
exit /b 0