#!/bin/bash
# Setup dotfiles from https://github.com/scillidan/dotfiles/tree/main/.config/_rime
# 1. mkdir -p ~/.local/share/fcitx5/rime
# 2. mkdir -p ~/Usr/Source/rime
# 3. git clone --depth=1 https://github.com/iDvel/rime-ice ~/Usr/Source/rime/rime-ice
# Update
# 1. cd %USERPROFILE%\Usr\Source\rime\rime-ice
# 2. git pull

RIME_SHARE="$HOME/.local/share/fcitx5/rime"
RIME_CONF="$HOME/.config/_rime/rime-ice"
RIME_SRC="$HOME/Usr/Source/rime"

declare -a CONFIG_FILES=(
	"default.custom.yaml"
	"user.yaml"
	"weasel.custom.yaml"
	"symbols.yaml"
)

for file in "${CONFIG_FILES[@]}"; do
	cp -f "$RIME_CONF/$file" "$RIME_SHARE/$file" || {
		echo "Failed to copy $file"
		exit 1
	}
done

declare -a LINK_FILES=(
	"cn_dicts"
	"en_dicts"
	"lua"
	"opencc"
	"others"
	"custom_phrase.txt"
	"melt_eng.dict.yaml"
	"melt_eng.schema.yaml"
	"rime_ice.dict.yaml"
	"rime_ice.schema.yaml"
	"symbols_caps_v.yaml"
	"symbols_v.yaml"
)

for file in "${LINK_FILES[@]}"; do
	ln -sf "$RIME_SRC/rime-ice/$file" "$RIME_SHARE/$file" || {
		echo "Failed to create link for $file"
		exit 1
	}
done

echo "Files copied and links created successfully."