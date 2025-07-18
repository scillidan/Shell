@echo off

cd C:\Users\User\Usr\OptWeb\Kokoro-FastAPI
call .venv\Scripts\activate.bat
set PHONEMIZER_ESPEAK_LIBRARY="C:\Users\User\Scoop\apps\espeak-ng\current\eSpeak NG\libespeak-ng.dll"
set PYTHONUTF8=1
set PROJECT_ROOT=%cd%
set USE_GPU=true
set USE_ONNX=false
set PYTHONPATH=%PROJECT_ROOT%;%PROJECT_ROOT%\api
set MODEL_DIR=src\models
set VOICES_DIR=src\voices\v1_0
set WEB_PLAYER_PATH=%PROJECT_ROOT%\web
uv run --no-sync python docker/scripts/download_model.py --output api/src/models/v1_0
uv run --no-sync uvicorn api.src.main:app --host 127.0.0.1 --port 8880

pause