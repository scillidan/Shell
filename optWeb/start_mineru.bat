@echo off

cd C:\Users\User\Usr\OptWeb\MinerU
call .venv\Scripts\activate.bat
mineru-gradio --server-name 0.0.0.0 --server-port 7860
