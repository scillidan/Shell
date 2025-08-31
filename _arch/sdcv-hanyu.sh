# Purpose: Search Chinese words with simplified and traditional forms in SDCV. Need dictionary "HanYuDaCiDian", see https://github.com/scillidan/share_hanyudacidian.
# Tools: hanconv, sdcv
# Usage: sdcv-hanyu.sh <Chinese_word>

#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <Chinese_word>"
	exit 1
fi

word="$1"

sc_word=$(hanconv t2s "$word")
sdcv --color --use-dict HanYuDaCiDian "$sc_word"

tc_word=$(hanconv s2t "$word")
sdcv --color --use-dict HanYuDaCiDian "$tc_word"
