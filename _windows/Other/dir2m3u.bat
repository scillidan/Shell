@echo off
rem Purpose: Create an M3U playlist from specified files and directories.
rem Usage: file.bat <file_or_directory>

setlocal enabledelayedexpansion

set "output_file=playlist.m3u"

if "%~1"=="" (
    echo No file or directory selected.
    exit /b
)

if exist "%output_file%" del "%output_file%"

:loop
for %%F in (%*) do (
    if exist "%%F" (
        if exist "%%~fF\*" (
            echo Processing directory: %%F
            echo #EXTM3U >> "%%~nxF.m3u"
            for /r "%%F" %%G in (*.mp3 *.m4a *.wav *.flac) do (
                echo %%G >> "%%~nxF.m3u"
            )
        ) else (
            echo Processing file: %%F
            echo #EXTM3U >> "%output_file%"
            echo %%~fF >> "%output_file%"
        )
    )
)

echo Done creating playlists.
endlocal