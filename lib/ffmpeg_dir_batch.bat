:: Purpose: Process video files from an input directory and save them to an output directory with specified commands and formats.
:: Tools: ffmpeg
:: Usage: file.bat -i <input_directory> -o <output_directory> -c <command_options> -f <output_format>

@echo off
setlocal enabledelayedexpansion

set input_dir=
set output_dir=
set command=
set output_format=

:parse_args
if "%~1"=="" goto process_files
if "%~1"=="-i" (
    set input_dir=%~2
    shift
    shift
) else if "%~1"=="-o" (
    set output_dir=%~2
    shift
    shift
) else if "%~1"=="-c" (
    set command=%~2
    shift
    shift
) else if "%~1"=="-f" (
    set output_format=%~2
    shift
    shift
) else (
    echo Unknown option: %~1
    exit /b 1
)
goto parse_args

:process_files
if not defined input_dir (
    echo Input directory is required.
    exit /b
)
if not defined output_dir (
    echo Output directory is required.
    exit /b
)
if not defined command (
    echo Command options are required.
    exit /b
)
if not defined output_format (
    echo Output file format is required.
    exit /b
)

if not exist "%output_dir%" (
    mkdir "%output_dir%"
)

for %%F in ("%input_dir%\*.*") do (
    set "filename=%%~nF"
    set "output_file=%output_dir%\!filename!.%output_format%"

    ffmpeg -i "%%F" !command! "!output_file!"
)

echo Processing complete.
endlocal