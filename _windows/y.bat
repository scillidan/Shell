@echo off
rem Write by GPT-4o mini🧙‍♂️, scillidan🤡

rem Create a temporary file to store the current working directory
set "tmpfile=%TEMP%\yazi-cwd.tmp"

rem Execute yazi with provided arguments and save the current working directory in the temporary file
rem The --cwd-file option is used to specify the path of the file where the current working directory will be saved
rem %* expands to all arguments passed to the script
yazi %* --cwd-file=%tmpfile%

rem Read the content of the temporary file into a variable named cwd
set "cwd="
set /p cwd=<"%tmpfile%"

rem Check if the current working directory has changed and if so, change to the saved directory
if defined cwd (
    rem Use for loop with delims= option to split the output of cd command into individual directories
    for /f "delims=" %%i in ('cd') do set "CURRENT_DIR=%%i"
    rem Check if the current working directory is not equal to the saved directory
    if /i not "%cwd%"=="%CURRENT_DIR%" (
        rem Change to the saved directory using cd command with change directory option (-d)
        cd /d "%cwd%"
    )
)

rem Delete the temporary file created earlier
del /f /q "%tmpfile%"