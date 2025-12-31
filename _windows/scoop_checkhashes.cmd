@echo off

pushd "%SCOOP%\apps\scoop\current"

pwsh bin\checkhashes.ps1 -App %* -Dir %USERHOME%\Usr\GitFork\scoop-bucket\bucket

popd