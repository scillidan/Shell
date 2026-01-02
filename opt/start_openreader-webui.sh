#!/bin/bash

set -e

cleanup() {
    unset BASE_DIR
    trap - EXIT
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        # Fill the path
        BASE_DIR="$HOME\Usr\OptAud\OpenReader-WebUI"
        ;;
    msys|cygwin)
        # Fill the path
        BASE_DIR="/c/Users/$(whoami)/Usr/OptAud/OpenReader-WebUI"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

pushd "$BASE_DIR" || exit 1

pnpm start

popd || exit 1
