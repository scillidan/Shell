#!/bin/bash
# Activate Python virtual environment and run PyLanguageTool.
# Dependencies: pylanguagetool
# Usage:
# (Linux) ./file.sh
# (Windows) bash ./file.sh

pushd "$USERHOME/Usr/Shell/.pyLanguagetool"

source ./Scripts/activate

# Read text from the systems clipboard
pylanguagetool --input-type html --lang en-US -c

popd

read -p "Press any key to continue..."
