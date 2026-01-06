@echo off
REM Get SHA256 hash from files and copy to clipboard
REM Authors: DeepSeek🧙‍♂️, scillidan🤡
REM Usage:
REM 1.1 Copy/createlink script in C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Right-click > Send to > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.bat <file1> <file2> ...

setlocal enabledelayedexpansion
set "hash_only_file=%temp%\_sha256_hash_%random%.txt"
type nul > "%hash_only_file%"

:main_loop
if "%~1"=="" goto :copy_to_clipboard

if not exist "%~1" (
    echo File not found: %~1
    goto :next_file
)

for /f "skip=1 tokens=1" %%i in ('certutil -hashfile "%~1" SHA256 2^>nul') do (
    REM Display only the hash
    echo %%i

    REM Store hash only (without filename)
    echo %%i >> "%hash_only_file%"

    goto :next_file
)

:next_file
shift
goto :main_loop

:copy_to_clipboard
if exist "%hash_only_file%" (
    for %%A in ("%hash_only_file%") do set "filesize=%%~zA"
    if !filesize! gtr 0 (
        REM Copy only hash values to clipboard
        type "%hash_only_file%" | clip
    )
)

:cleanup
if exist "%hash_only_file%" del "%hash_only_file%" 2>nul