#!/bin/bash
# Markdown Translator
# Source: https://github.com/rockbenben/subtitle-translator
# Install:
# git clone --depth=1 https://github.com/rockbenben/subtitle-translator
# cd subtitle-translator
# yarn
# yarn build:lang en
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
pushd "$BASE_DIR/Usr/OptTxt/subtitle-translator" || exit 1

# bun add -g serve
serve out

popd || exit 1