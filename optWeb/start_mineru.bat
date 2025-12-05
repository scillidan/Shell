@echo off

setlocal

cd C:\Users\User\Usr\OptWeb\MinerU
call .venv\Scripts\activate.bat
rem set MINERU_VIRTUAL_VRAM_SIZE=10
mineru-gradio --server-name 0.0.0.0 --server-port 7860

endlocal