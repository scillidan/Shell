#!/bin/bash
#
# Buzz
# Source: https://github.com/chidiwilliams/buzz
#
# Install:
# uv venv .buzz --python 3.12
# uv pip install -U torch==2.8.0+cu129 torchaudio==2.8.0+cu129 --index-url https://download.pytorch.org/whl/cu129
# uv pip install nvidia-cublas-cu12==12.9.1.4 nvidia-cuda-cupti-cu12==12.9.79 nvidia-cuda-runtime-cu12==12.9.79 --extra-index-url https://pypi.ngc.nvidia.com
# pip install buzz-captions
# uv pip install hf_transfer
# set HF_HUB_ENABLE_HF_TRANSFER=0
# python -m buzz
#
# Usage:
# (bash) file.sh

set -e

cleanup() {
    unset BASE_DIR
    unset VENV_ACT
    unset MINERU_VIRTUAL_VRAM_SIZE
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        BASE_DIR="$HOME"
        VENV_ACT="bin/activate"
        ;;
    msys|cygwin)
        BASE_DIR="/c/Users/$USERNAME"
        VENV_ACT="Scripts/activate"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

pushd "$BASE_DIR/Usr/OptAud/.buzz" || exit 1

source "$VENV_ACT"
buzz

popd || exit 1