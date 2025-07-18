:: Write by GPT-4o mini👨‍💻, scillidan🤡
:: Purpose: Concatenate various audio file formats into a single MP3 file.
:: Tools: ffmpeg
:: Usage: cli.bat <input_dir> [<output_file>]

@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: cli.bat ^<input_dir^> [^<output_file^>]
    exit /b 1
)

set "input_dir=%~1"
is provided
if "%~2"=="" (
    for %%D in ("%input_dir%") do set "output_file=%%~nxD.mp3"
) else (
    set "output_file=%~2"
)

set "temp_dir=%temp%\converted_audio"
mkdir "!temp_dir!" >nul 2>&1

for %%f in ("%input_dir%\*.mp3" "%input_dir%\*.wav" "%input_dir%\*.flac" "%input_dir%\*.ogg" "%input_dir%\*.opus" "%input_dir%\*.m4a") do (
    ffmpeg -i "%%~f" "!temp_dir!\%%~nf.wav"
)

set "concat_file=%temp%\files_to_concat.txt"

> "!concat_file!" (
    for %%f in ("!temp_dir!\*.wav") do (
        echo file '%%~f' ^&
    )
)

if not exist "!concat_file!" (
    echo No audio files found in "%input_dir%"
    exit /b 1
)

for /f "usebackq" %%A in ("!concat_file!") do set "not_empty=1"
if not defined not_empty (
    echo No audio files found in "%input_dir%"
    exit /b 1
)

set "temp_output=%temp%\concatenated_audio.wav"
ffmpeg -f concat -safe 0 -i "!concat_file!" -c copy "!temp_output!"

if %errorlevel% neq 0 (
    echo An error occurred during the concatenation process.
    exit /b 1
)

ffmpeg -i "!temp_output!" -codec:a libmp3lame "!output_file!"

if %errorlevel% neq 0 (
    echo An error occurred during the conversion to MP3.
    exit /b 1
)

rd /s /q "!temp_dir!"
del "!concat_file!"
del "!temp_output!"

echo Concatenation completed: "!output_file!"