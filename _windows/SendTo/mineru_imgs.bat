@echo off
REM Write by GPT-4o mini🧙‍♂️, scillidan🤡
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <img1> <img2> ...
REM Reference:
REM - https://opendatalab.github.io/MinerU/usage/cli_tools/

setlocal enabledelayedexpansion

rem Custom user environment variables here
set "MINERU=％USER%\Usr\OptTxt\MinerU\.venv\Scripts\mineru.exe"
set "FLAG=--backend vlm-transformers"
set "OPEN_OUTPUT=true"
set "OUTPUT=%USERHOME%\Documents\MinerU"

if not exist "%OUTPUT%" mkdir "%OUTPUT%"

echo ================================================
echo MinerU Processor
echo ================================================
echo.

rem Flag to indicate files were provided on the command line / drag-drop
set "FILES_PROVIDED=0"

rem Method 1: Check for dragged files
if not "%~1"=="" (
    set "FILES_PROVIDED=1"
    echo Processing dragged files...
    echo.
    for %%F in (%*) do (
        if exist "%%F" (
            echo Processing: %%F
            start /wait "" "%MINERU%" %FLAG% --path "%%F" --output "%OUTPUT%"
        ) else (
            echo File not found: %%F
        )
    )
)

rem If files were provided, skip clipboard processing
if "%FILES_PROVIDED%"=="1" goto SKIP_CLIPBOARD

rem Method 2: Check clipboard for files
echo Checking clipboard for file paths...
echo.

set "CLIPBOARD_FILES="
for /f "delims=" %%F in ('powershell -command "try { [System.Windows.Forms.Clipboard]::GetFileDropList() } catch { }" 2^>nul') do (
    if not defined CLIPBOARD_FILES (
        set "CLIPBOARD_FILES=%%F"
    ) else (
        set "CLIPBOARD_FILES=!CLIPBOARD_FILES! %%F"
    )
)

if defined CLIPBOARD_FILES (
    echo Found files in clipboard.
    echo.
    for %%F in (!CLIPBOARD_FILES!) do (
        echo Processing: %%~F
        if exist "%%~F" (
            start /wait "" "%MINERU%" %FLAG% --path "%%~F" --output "%OUTPUT%"
        ) else (
            echo File not found: %%~F
        )
    )
)

rem Method 3: Try to save clipboard image
echo Checking clipboard for image data...
echo.

rem Generate a proper filename with locale-independent date and time
for /f "delims=" %%a in ('powershell -command "Get-Date -Format 'yyyyMMdd-HHmmss'"') do (
    set "BASE_NAME=_clip_%%a"
)

set "TEMP_INDEX=1"

:CREATE_TEMP_FILE
set "TEMP_FILE=%TEMP%\!BASE_NAME!_0!TEMP_INDEX!.png"
if exist "!TEMP_FILE!" (
    set /a TEMP_INDEX+=1
    goto CREATE_TEMP_FILE
)

rem Try to save clipboard image using a simpler approach
echo Trying to save clipboard image...
powershell -command "$ErrorActionPreference='SilentlyContinue'; Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $img = [System.Windows.Forms.Clipboard]::GetImage(); if ($img) { $img.Save('%TEMP_FILE%', [System.Drawing.Imaging.ImageFormat]::Png); Write-Output 'SAVED'; } else { Write-Output 'NO_IMAGE'; }" > "%TEMP%\clip_result.txt" 2>nul

set "CLIP_RESULT="
for /f "delims=" %%R in ('type "%TEMP%\clip_result.txt" 2^>nul') do set "CLIP_RESULT=%%R"

if "!CLIP_RESULT!"=="SAVED" (
    if exist "!TEMP_FILE!" (
        echo Image saved to: !TEMP_FILE!
        echo.
        echo Processing saved image...
        start /wait "" "%MINERU%" %FLAG% --path "!TEMP_FILE!" --output "%OUTPUT%"
    )
)

:SKIP_CLIPBOARD
rem Clean up temp files after processing (if any)
echo Cleaning up temporary files...
if exist "%TEMP%\clip_result.txt" del "%TEMP%\clip_result.txt"
if exist "!TEMP_FILE!" del "!TEMP_FILE!"

:OPEN_OUTPUT
rem Open output path only once at the end
if "%OPEN_OUTPUT%"=="true" (
    echo Open the output folder
    echo.
    echo Wait for the process to complete...
    start "" "explorer" "%OUTPUT%"
)

endlocal
exit /b