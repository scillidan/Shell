#!/bin/bash

set -e

cleanup() {
    if [[ -n "$VENV_ACT" ]]; then
        deactivate
    fi
    unset MINERU_VIRTUAL_VRAM_SIZE
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        # Arch Linux
        VENV_ACT=".venv/bin/activate"
        ;;
    msys|cygwin)
        # Windows (Git Bash or Cygwin)
        VENV_ACT=".venv/Scripts/activate"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

pushd "$USERHOME/Usr/OptTxt/MinerU" || exit 1

source "$VENV_ACT"
# export MINERU_VIRTUAL_VRAM_SIZE=10
mineru-gradio --server-name 0.0.0.0 --server-port 7860

popd || exit 1