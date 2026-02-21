#!/bin/bash
# Usage:
# (bash) file.sh

set -e

cleanup() {
    unset BASE_DIR
    unset VENV_ACT
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        BASE_DIR="$HOME"
        VENV_ACT=".venv/bin/activate"
        ;;
    msys|cygwin)
        BASE_DIR="/c/Users/$USERNAME"
        VENV_ACT=".venv/Scripts/activate"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

pushd "$BASE_DIR/Usr/OptTxt/DeepSeek-OCR-WebUI" || exit 1

source "$VENV_ACT"
python web_service_gpu.py

popd || exit 1