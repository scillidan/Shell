rem Purpose: Create a Keypirinha package archive from a specified directory.
rem Tools: 7z
rem Usage: file.bat <dir>

@echo off
setlocal

if "%~1"=="" (
    echo Usage: %0 ^<dir^>
    exit /b 1
)

set "dir=%~1"

if not exist "%dir%" (
    echo The directory "%dir%" does not exist.
    exit /b 1
)

7z a -x!.git "%dir%.zip" "%dir%\*"
mv "%dir%.zip" "%dir%.keypirinha-package"

if %errorlevel% neq 0 (
    echo Error occurred while creating the archive.
    exit /b %errorlevel%
)

echo Archive created successfully: "%dir%.keypirinha-package"
endlocal