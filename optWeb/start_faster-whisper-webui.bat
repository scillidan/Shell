@echo off

cd C:\Users\User\Usr\OptWeb\faster-whisper-webui
start .venv\Scripts\python.exe app.py --server_name 127.0.0.1 --server_port 7830 --input_audio_max_duration -1 --whisper_implementation "faster-whisper" --default_model_name "large-v2" --vad_parallel_devices "0" --auto_parallel true --output_dir "C:\Users\User\Downloads"

pause