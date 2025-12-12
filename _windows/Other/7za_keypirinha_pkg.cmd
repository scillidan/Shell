@echo off
rem Purpose: Create a Keypirinha package archive from a specified directory.
rem Tools: 7z
rem Usage: file.bat <fullpath>

setlocal

if "%~1"=="" (
    echo Usage: %0 ^<dir^>
    exit /b 1
)

set "target_directory=%~1"

if not exist "%target_directory%" (
    echo The directory "%target_directory%" does not exist.
    exit /b 1
)

7z a -x!.git "%target_directory%.zip" "%target_directory%\*"
move /Y "%target_directory%.zip" "%target_directory%.keypirinha-package"

if %errorlevel% neq 0 (
    echo Error occurred while creating the archive.
    exit /b %errorlevel%
)

echo Archive created successfully: "%target_directory%.keypirinha-package"
endlocal