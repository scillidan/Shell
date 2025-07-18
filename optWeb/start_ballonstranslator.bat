@echo off

cd C:\Users\User\Usr\OptWeb\SakuraLLM
start .venv\Scripts\python.exe server.py --trust_remote_code --model_name_or_path models/sakura-13b-lnovel-v0.9b-Q2_K.gguf --model_version 0.9 --no-auth --llama_cpp --use_gpu --log debug

cd C:\Users\User\Usr\OptWeb\BallonsTranslator
start .venv\Scripts\python.exe launch.py

pause

