@echo off

cd %USER%\Usr\Shell\.pyLanguagetool
call .\Scripts\activate.bat
pylanguagetool --api-url http://ubuntu22:8040/v2/ --input-type html --lang en-US -c

pause