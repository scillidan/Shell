#!/bin/bash
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

pushd "$BASE_DIR/Usr/OptTxt/MinerU" || exit 1

source "$VENV_ACT"
# export MINERU_VIRTUAL_VRAM_SIZE=10
mineru-gradio --server-name 0.0.0.0 --server-port 7860

popd || exit 1