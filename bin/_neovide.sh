#!/bin/bash

export XDG_CONFIG_HOME="$HOME/Usr/Data"
export XDG_DATA_HOME="$HOME/Usr/Data"

neovide --size=1250x720 --frame none --no-tabs --neovim-bin nvim $@