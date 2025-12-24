@echo off

pushd "%SCOOP%\apps\scoop\current"

pwsh bin\checkver.ps1 -App %* -Dir %USERHOME%\Usr\GitFork\Bucket\bucket

popd