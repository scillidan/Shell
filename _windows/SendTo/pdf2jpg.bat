:: Purpose: Export a specific page from PDF files as JPEG images using ImageMagick.
:: Tools: magick
:: Usage: file.bat <input_pdf_files>

@echo off
setlocal enabledelayedexpansion

for %%I in (%*) do (
    set /p "pageNum=Enter the page number to export (default is 1): "

    if "!pageNum!"=="" (
        set "pageNum=0"
    ) else (
        set /a pageNum-=1
    )

    for %%F in ("%%I") do (
        set "filename=%%~nF"
        magick convert -density 300 "%%I[!pageNum!]" -flatten -quality 90 "!filename!.jpg"
    )
)

endlocal