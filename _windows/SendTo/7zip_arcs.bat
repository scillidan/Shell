@echo off
REM 7z extractor that removes common root folder
REM Usage:
REM 1.1 Copy/makelink script into C:\Users\User\AppData\Roaming\Microsoft\Windows\SendTo
REM 1.2 Select files > Context Menu > SendTo > script.bat
REM 2. Drag and drop files onto this script
REM 3. script.cmd <arc1> <arc2> ...

setlocal enabledelayedexpansion

rem === find 7z executable ===
for %%Z in (7z.exe 7za.exe 7zr.exe) do (
  where %%Z >nul 2>&1 && set "DC=%%Z" && goto :found7z
)
echo 7z not found in PATH
goto :EOF
:found7z

rem === check if second arg is destination dir ===
set "GLOBAL_DEST="
if not "%~2"=="" (
  if exist "%~2\" set "GLOBAL_DEST=%~2"
)

if "%~1"=="" goto :EOF

rem === process archives ===
for %%A in (%*) do (
  if defined GLOBAL_DEST (
    if /I "%%~fA"=="%~2" (
      rem skip destination arg
    ) else (
      call :process "%%~fA"
    )
  ) else (
    call :process "%%~fA"
  )
)

echo All done
endlocal
goto :EOF

:process
setlocal enabledelayedexpansion
set "ARCH=%~1"

if not exist "%ARCH%" goto :eof
if exist "%ARCH%\" goto :eof

echo Processing: "%ARCH%"

rem === set destination folder ===
if defined GLOBAL_DEST (
  set "DEST=%GLOBAL_DEST%\%~n1"
) else (
  set "DEST=%~dp1%~n1"
)
if "%DEST:~-1%"=="\" set "DEST=%DEST:~0,-1%"
if not exist "%DEST%" md "%DEST%" >nul 2>&1

rem === list archive contents ===
set "TMP=%TEMP%\7zxt_%RANDOM%_%RANDOM%"
md "%TMP%" >nul 2>&1
"%DC%" l -ba -slt "%ARCH%" > "%TMP%\_list.txt" 2>nul
if errorlevel 1 (
  rd /s /q "%TMP%" >nul 2>&1
  goto :eof
)

rem === check for common root folder ===
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
if defined ROOT if !ALLSAME! EQU 1 set /a STRIP=1

rem === extract with or without root folder ===
if !STRIP! EQU 1 (
  "%DC%" x -y -o"%TMP%" "%ARCH%"
  if errorlevel 1 (
    rd /s /q "%TMP%" >nul 2>&1
    goto :eof
  )
  if exist "%TMP%\!ROOT!\" (
    robocopy "%TMP%\!ROOT!" "%DEST%" /e /move >nul 2>&1
    rd /s /q "%TMP%\!ROOT!" >nul 2>&1
  )
  rd /s /q "%TMP%" >nul 2>&1
) else (
  "%DC%" x -y -o"%DEST%" "%ARCH%"
  if errorlevel 1 (
    rd /s /q "%TMP%" >nul 2>&1
    goto :eof
  )
  rd /s /q "%TMP%" >nul 2>&1
)

echo Extraction finished for "%ARCH%"

endlocal
goto :eof