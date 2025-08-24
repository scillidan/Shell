# https://github.com/scillidan/Keypirinha-PuzzTools/blob/main/transforms.py

#!/bin/bash

# Ensure we have 2 arguments
if [[ $# -lt 2 ]]; then
	echo "Usage: $0 conversion_type string"
	exit 1
fi

type="$1"
input="$2"

case "$type" in
2winurl)
	# Replace '/' with '\'
	echo "$input" | sed 's|/|\\|g'
	;;

2unixurl)
	# Replace '\' with '/'
	echo "$input" | sed 's|\\|/|g'
	;;

2raw)
	# github-url to raw-url
	echo "$input" | sed -E 's|https://github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)|https://raw.githubusercontent.com/\1/\2/refs/heads/\3/\4|'
	;;

2gh)
	# github-url to gh-url
	echo "$input" | sed -E 's|https://github.com/([^/]+)/([^/]+)(/.*)?|\1/\2|'
	;;

2atomc)
	# github-url to github-commits-atom-feed-url
	echo "$input" | sed -E 's|https://github.com/([^/]+)/([^/]+)(/.*)?|https://github.com/\1/\2/commits.atom|'
	;;

2atomr)
	# github-url to github-releases-atom-feed-url
	echo "$input" | sed -E 's|https://github.com/([^/]+)/([^/]+)(/.*)?|https://github.com/\1/\2/releases.atom|'
	;;

*)
	echo "Unknown conversion type: $type"
	exit 1
	;;
esac
