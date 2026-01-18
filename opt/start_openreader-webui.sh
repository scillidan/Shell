#!/bin/bash
# OpenReader-WebUI
# Source: https://github.com/richardr1126/OpenReader-WebUI
# Install:
# git clone --depth=1 https://github.com/richardr1126/OpenReader-WebUI
# cd OpenReader-WebUI
# pnpm i
# cp template.env .env
# subl .env
# (Kokoro-FastAPI)
# API_BASE=http://localhost:8880/v1/
# pnpm build
# pnpm start
# Usage:
# (bash) file.sh

set -e

cleanup() {
    unset BASE_DIR
    trap - EXIT
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        BASE_DIR="$HOME"
        ;;
    msys|cygwin)
        BASE_DIR="/c/Users/$USERNAME"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

# Fill the path
pushd "$BASE_DIR/Usr/OptAud/OpenReader-WebUI" || exit 1

pnpm start

popd || exit 1
