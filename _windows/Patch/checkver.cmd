@echo off

pushd "%USER%\Scoop\apps\scoop\current"

pwsh bin\checkver.ps1 -App %* -Dir %USER%\Usr\GitFork\Bucket\bucket

popd