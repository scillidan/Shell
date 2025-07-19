:: Purpose: Process an input string using MeCab and format it in Wakati.
:: Tools: MeCab
:: Usage: file.bat <input_string>

@echo off

setlocal EnableDelayedExpansion

:: Set the code page to UTF-8
chcp 65001 > nul

:: Replace \n with a space in the input string to avoid issues
set "INPUT_STRING=%*"
set "INPUT_STRING=!INPUT_STRING:\n= !"

:: Write the input string to a file
echo !INPUT_STRING! > "input.txt"

:: Run MeCab with the input string
:: Make sure to replace the path below with the correct path to your MeCab dictionary
mecab -d "C:\Users\User\Download\yomichan\unidic-cwj-202302" "input.txt" -o "out.txt" -O wakati

:: Check if MeCab output file exists
if exist "out.txt" (
    :: Display the output from MeCab
    type "out.txt"
) else (
    echo MeCab output file not found.
)

:: Clean up temporary files
del "input.txt" >nul 2>&1
del "out.txt" >nul 2>&1

endlocal