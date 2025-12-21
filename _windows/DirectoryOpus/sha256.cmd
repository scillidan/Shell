@echo off
@rem Purpose: Generate SHA256 checksums for files in a specified directory, skipping existing checksums.
@rem Tools: sha256
@rem Usage: file.bat <directory>

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Please provide a directory as an argument.
    exit /b
)

cd /d "%~1" || (
    echo The directory "%~1" does not exist.
    exit /b
)

for %%f in (*.*) do (
    if /i not "%%~xf"==".sha256" (
        if not exist "%%~nf.sha256" (
            sha256 -s "%%f"
        ) else (
            echo Skipping "%%f", SHA256 already exists.
        )
    )
)

endlocal