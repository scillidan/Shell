@echo off
rem Write by GPT-4o mini🧙‍♂️, scillidan🤡
rem 1. Select archive files in File Explorer, drag them onto this batch file.
rem 2. Put script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo. Select archives files the goto Context Menu > SendTo > 7zip_arcs.bat.
rem 3. Run `7zip_arcs "C:\path\to\archive"` or `7zip_arcs "archive1" "archive2"`.
rem PS: Only tested part of the input file format.

setlocal enabledelayedexpansion

rem === find 7z executable ===
set "SEVEN="
for %%Z in (7z.exe 7za.exe 7zr.exe) do (
  where %%Z >nul 2>&1 && set "SEVEN=%%Z" && goto :found7z
)
echo ERROR: 7z not found in PATH. Please install 7-Zip or put 7z.exe in PATH.
goto :EOF
:found7z

rem === determine if second arg is a destination directory ===
set "GLOBAL_DEST="
if not "%~2"=="" (
  if exist "%~2\" (
    set "GLOBAL_DEST=%~2"
  )
)

rem === no-arg help ===
if "%~1"=="" (
  echo Usage:
  echo   %~nx0.bat archive1.zip [existingDestDir]
  echo or drag & drop archive files onto this script.
  goto :EOF
)

rem === process each argument; skip the destination arg if provided ===
for %%A in (%*) do (
  rem if this iteration is the destination argument, skip it
  if defined GLOBAL_DEST (
    if /I "%%~fA"=="%~2" (
      echo Skipping destination argument "%%~fA"
    ) else (
      call :process "%%~fA"
    )
  ) else (
    call :process "%%~fA"
  )
)

echo.
echo All done.
endlocal
goto :EOF

rem === subroutine to process one archive (called as: call :process "path") ===
:process
setlocal enabledelayedexpansion
set "ARCH=%~1"

if not exist "%ARCH%" (
  echo Skipping missing file "%ARCH%"
  endlocal
  goto :eof
)

rem skip directories that might have been dropped
if exist "%ARCH%\" (
  echo Skipping directory "%ARCH%"
  endlocal
  goto :eof
)

echo.
echo Processing: "%ARCH%"

rem determine destination folder
if defined GLOBAL_DEST (
  set "DEST=%GLOBAL_DEST%\%~n1"
) else (
  set "DEST=%~dp1%~n1"
)
rem remove trailing backslash if any
if "%DEST:~-1%"=="\" set "DEST=%DEST:~0,-1%"

if not exist "%DEST%" md "%DEST%" >nul 2>&1

rem temporary extraction folder
set "TMP=%TEMP%\7zxt_%RANDOM%_%RANDOM%"
md "%TMP%" >nul 2>&1

rem list entries with details
"%SEVEN%" l -ba -slt "%ARCH%" > "%TMP%\_list.txt" 2>nul
if errorlevel 1 (
  echo ERROR: failed to list archive "%ARCH%".
  rd /s /q "%TMP%" >nul 2>&1
  endlocal
  goto :eof
)

rem parse for common top-level path segment
set "ROOT="
set /a ALLSAME=1
for /f "usebackq delims=" %%L in ("%TMP%\_list.txt") do (
  set "LN=%%L"
  if "!LN:~0,7!"=="Path = " (
    set "P=!LN:~7!"
    for /f "delims=\/" %%R in ("!P!") do (
      if not defined ROOT (
        set "ROOT=%%R"
      ) else (
        if /I "%%R" NEQ "!ROOT!" set /a ALLSAME=0
      )
    )
  )
)

set /a STRIP=0
if defined ROOT if !ALLSAME! EQU 1 (
  if not "!ROOT!"=="" set /a STRIP=1
)

rem extract
if !STRIP! EQU 1 (
  echo Archive appears to have single top-level folder: "!ROOT!"
  echo Extracting to temporary folder...
  "%SEVEN%" x -y -o"%TMP%" "%ARCH%"
  if errorlevel 1 (
    echo ERROR: extraction failed for "%ARCH%"
    rd /s /q "%TMP%" >nul 2>&1
    endlocal
    goto :eof
  )
  rem move contents of the top-level folder into destination
  if exist "%TMP%\!ROOT!\" (
    echo Moving contents of "%TMP%\!ROOT!\" to "%DEST%" ...
    rem robocopy used to move all files and folders
    robocopy "%TMP%\!ROOT!" "%DEST%" /e /move >nul 2>&1
    rd /s /q "%TMP%\!ROOT!" >nul 2>&1
  ) else (
    echo WARNING: expected folder "%TMP%\!ROOT!\" not found after extraction.
  )
  rd /s /q "%TMP%" >nul 2>&1
) else (
  echo Extracting directly to "%DEST%" ...
  "%SEVEN%" x -y -o"%DEST%" "%ARCH%"
  if errorlevel 1 (
    echo ERROR: extraction failed for "%ARCH%"
    rd /s /q "%TMP%" >nul 2>&1
    endlocal
    goto :eof
  )
  rd /s /q "%TMP%" >nul 2>&1
)

echo Extraction finished for "%ARCH%".

rem optionally move original archive to Recycle Bin if DEL_INPUT is set (non-empty)
if defined DEL_INPUT (
  if not "%DEL_INPUT%"=="" (
    echo Moving "%ARCH%" to Recycle Bin...
    rem use PowerShell Shell.Application COM object to move to Recycle Bin
    powershell -NoProfile -Command "$s=New-Object -ComObject Shell.Application; $s.Namespace(0xA).MoveHere('%ARCH%')"
  )
)

endlocal
goto :eof