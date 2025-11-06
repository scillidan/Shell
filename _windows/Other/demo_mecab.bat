rem Purpose: Process an input string using MeCab and format it in Wakati.
rem Tools: MeCab
rem Usage: file.bat <input_string>

@echo off

setlocal EnableDelayedExpansion

rem Set the code page to UTF-8
chcp 65001 > nul

rem Replace \n with a space in the input string to avoid issues
set "INPUT_STRING=%*"
set "INPUT_STRING=!INPUT_STRING:\n= !"

rem Write the input string to a file
echo !INPUT_STRING! > "input.txt"

rem Run MeCab with the input string
rem Make sure to replace the path below with the correct path to your MeCab dictionary
mecab -d "C:\Users\User\Download\yomichan\unidic-cwj-202302" "input.txt" -o "out.txt" -O wakati

rem Check if MeCab output file exists
if exist "out.txt" (
    rem Display the output from MeCab
    type "out.txt"
) else (
    echo MeCab output file not found.
)

rem Clean up temporary files
del "input.txt" >nul 2>&1
del "out.txt" >nul 2>&1

endlocal