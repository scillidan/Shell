#!/bin/bash
# Activate Python virtual environment and run PyLanguageTool.
# Dependencies: pylanguagetool
# Usage:
# (Linux) ./file.sh
# (Windows) bash ./file.sh

cleanup() {
    unset BASE_DIR
    unset $VENV_ACT
    trap - EXIT
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        # Fill the path
        BASE_DIR="$HOME/Usr/Shell/.pyLanguagetool"
        VENV_ACT="./bin/activate"
        ;;
    msys|cygwin)
        # Fill the path
        BASE_DIR="/c/Users/$(whoami)/Usr/Shell/.pyLanguagetool"
        VENV_ACT="./Scripts/activate"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

pushd "$BASE_DIR" || exit 1

if [ -f "$VENV_ACT" ]; then
    source "$VENV_ACT"
else
    echo "Virtual environment not found at: $VENV_ACT"
    exit 1
fi

# Read text from the systems clipboard
pylanguagetool --input-type html --lang en-US -c $*

popd || exit 1

read -p "Press any key to continue..."