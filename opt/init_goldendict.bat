@echo off

setlocal

set "GOLDENDICT_DATA=%SCOOP%\apps\goldendict\current\portable"
set "GOLDENDICT_HOME=%SCOOP%\apps\goldendict\current"
rem Custom user environment variables here
set "GOLDENDICT_CONF=%USER%\Usr\Git\dotfiles\.config\_goldendict"
set "GOLDENDICT_SRC=%USER%\Usr\Source\goldendict"
set "GOLDENDICT_DL=%USER%\Usr\Download\goldendict"

rmdir /S /Q "%GOLDENDICT_HOME%\extras"
rmdir /S /Q "%GOLDENDICT_HOME%\icons"
rmdir /S /Q "%GOLDENDICT_DATA%\fonts"
rmdir /S /Q "%GOLDENDICT_DATA%\styles"
mklink /J "%GOLDENDICT_HOME%\extras" "%GOLDENDICT_SRC%\GoldenDict-Full-Dark-Theme\GoldenDict\extras"
mklink /J "%GOLDENDICT_HOME%\icons" "%GOLDENDICT_SRC%\GoldenDict-Full-Dark-Theme\GoldenDict\icons"
mklink /J "%GOLDENDICT_DATA%\fonts" "%GOLDENDICT_SRC%\GoldenDict-Full-Dark-Theme\GoldenDict\fonts"
mkdir "%GOLDENDICT_DATA%\styles\Dark"
type "%GOLDENDICT_SRC%\GoldenDict-Full-Dark-Theme\GoldenDict\styles\Dark\article-style.css" "%GOLDENDICT_CONF%\article-style_user.css" > "%GOLDENDICT_DATA%\styles\Dark\article-style.css"
mklink "%GOLDENDICT_DATA%\styles\Dark\qt-style.css" "%GOLDENDICT_SRC%\GoldenDict-Full-Dark-Theme\GoldenDict\styles\Dark\qt-style.css"

rmdir /S /Q "%GOLDENDICT_HOME%\content"
mkdir "%GOLDENDICT_HOME%\content"
mklink /J "%GOLDENDICT_HOME%\content\morphology" "%GOLDENDICT_DL%\morphology"
mklink /J "%GOLDENDICT_HOME%\content\stardict" "%GOLDENDICT_DL%\stardict"
mkdir "%GOLDENDICT_HOME%\content\sound-dirs"
rem https://gist.github.com/scillidan/fd36bd6c9a84b565c131cccc4508df7b
mklink /J "%GOLDENDICT_HOME%\content\sound-dirs\Forvo_pron" "%GOLDENDICT_DL%\sound-dirs\Forvo_pron"
mklink "%GOLDENDICT_HOME%\content\sound-dirs\pronunciations-en.zips" "%GOLDENDICT_DL%\sound-dirs\pronunciations-en.zips"

endlocal

pause