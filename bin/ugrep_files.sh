#!/bin/bash

set -e

cleanup() {
    if [[ -n "$BASE_DIR" ]]; then
        unset BASE_DIR
    fi
}
trap cleanup EXIT

case "$OSTYPE" in
    linux-gnu*)
        # Linux
        BASE_DIR="$HOME"
        ;;
    msys|cygwin)
        # Windows (Git Bash or Cygwin)
        BASE_DIR="/c/Users/$USERNAME"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

function ugrep_files() {
    case "$1" in
        shortcut)
            ugrep --smart-case --recursive --split --fuzzy=best -Q \
            "$BASE_DIR/Usr/File/file_rofi-shortcuts/shortcut" \
            "$BASE_DIR/Usr/File/file_rofi-shortcuts/shortcut_windows" \
            "$BASE_DIR/Usr/File/file_rofi-shortcuts/shortcut_dev"
        ;;
        cheatsheet)
            ugrep --smart-case --recursive --split --fuzzy=best -Q \
            "$BASE_DIR/Usr/File/file_rofi-shortcuts/cheatsheet" \
            "$BASE_DIR/Usr/File/file_rofi-shortcuts/cheatsheet_2zh" \
            "$BASE_DIR/Usr/Git/Mark" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/jaffa" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/laguna" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/lyra-a" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/lyra-b" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/nineveh" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/orion-a" \
            "$BASE_DIR/Usr/ProjSite/BYYA-site/content.zh/docs/sheet"
        ;;
        *)
            echo "Usage: ugrep_files {shortcut|cheatsheet}"
            exit 1
        ;;
    esac
}

ugrep_files "$@"