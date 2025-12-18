@echo off
rem Setup dotfiles from https://github.com/scillidan/dotfiles/tree/main/.config/_rime
rem 1. mkdir "%USER%\Usr\Source\rime"
rem 2. git clone --depth=1 https://github.com/iDvel/rime-ice %USERPROFILE%\Usr\Source\rime\rime-ice
rem Update
rem 1. cd %USERPROFILE%\Usr\Source\rime\rime-ice
rem 2. git pull

setlocal

rem Custom user environment variables here
rem set "RIME_SHARE=%APPDATA%\rime"
set "RIME_SHARE=%USER%\Usr\Data\rime"
set "RIME_DOTDIR=%DOTFILES_DIR%\.config\_rime\rime-ice"
set "RIME_SRC=%USER%\Usr\Source\rime"

set PERSONAL_FILE=default.custom.yaml user.yaml weasel.custom.yaml symbols.yaml

for %%F in (%PERSONAL_FILE%) do (
    if exist "%RIME_SHARE%\%%F" (
        del "%RIME_SHARE%\%%F" || (
            echo Failed to delete %%F
            exit /b 1
        )
    )
    mklink "%RIME_SHARE%\%%F" "%RIME_DOTDIR%\%%F" || (
        echo Failed to mklink %%F
        exit /b 1
    )
)

set RIMEICE_FILE=custom_phrase.txt melt_eng.dict.yaml melt_eng.schema.yaml rime_ice.dict.yaml rime_ice.schema.yaml symbols_caps_v.yaml symbols_v.yaml
set RIMEICE_DIR=cn_dicts en_dicts lua opencc others

for %%F in (%RIMEICE_FILE%) do (
    if exist "%RIME_SHARE%\%%F" (
        del "%RIME_SHARE%\%%F" || (
            echo Failed to delete %%F
            exit /b 1
        )
    )
    mklink "%RIME_SHARE%\%%F" "%RIME_SRC%\rime-ice\%%F" || (
        echo Failed to create link for %%F
        exit /b 1
    )
)

for %%F in (%RIMEICE_DIR%) do (
    if exist "%RIME_SHARE%\%%F" (
        rmdir /s /q "%RIME_SHARE%\%%F" || (
            echo Failed to delete directory %%F
            exit /b 1
        )
    )
    mklink /J "%RIME_SHARE%\%%F" "%RIME_SRC%\rime-ice\%%F" || (
        echo Failed to create link for %%F
        exit /b 1
    )
)

echo Files copied and links created successfully.

endlocal

pause