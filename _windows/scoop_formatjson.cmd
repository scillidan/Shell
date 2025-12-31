@echo off

pushd "%SCOOP%\apps\scoop\current"

pwsh bin\formatjson.ps1 -App %* -Dir %USERHOME%\Usr\GitFork\scoop-bucket\bucket

popd