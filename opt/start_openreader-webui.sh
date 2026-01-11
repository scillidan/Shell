#!/bin/bash

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
