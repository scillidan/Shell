@echo off
REM Generate SHA256 checksums for files in a specified directory.
REM Dependences: sha256
REM Usage: script.cmd <directory>

@echo off
cd /d "%~1" 2>nul || (echo Invalid directory & exit /b)

for %%f in (*.*) do (
    if /i not "%%~xf"==".sha256" (
        if not exist "%%~nf.sha256" sha256 -s "%%f" else echo Skipping: "%%f"
    )
)