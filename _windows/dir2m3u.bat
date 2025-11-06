rem Purpose: Create a playlist file from specified audio files and directories.
rem Tools: Command Prompt
rem Usage: file.bat <file_or_directory>

@echo off
setlocal enabledelayedexpansion

set "outputFile=playlist.m3u"

if "%~1"=="" (
    echo No file or directory selected.
    exit /b
)

if exist "%outputFile%" del "%outputFile%"

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
            echo #EXTM3U >> "%outputFile%"
            echo %%~fF >> "%outputFile%"
        )
    )
)

echo Done creating playlists.
endlocal