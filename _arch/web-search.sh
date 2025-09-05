#!/usr/bin/env bash
# https://github.com/miroslavvidovic/rofi-scripts/blob/master/web-search.sh
# -----------------------------------------------------------------------------
# Info:
#   author:    Miroslav Vidovic
#   file:      web-search.sh
#   created:   24.02.2017.-08:59:54
#   revision:  ---
#   version:   1.0
# -----------------------------------------------------------------------------
# Requirements:
#   rofi
# Description:
#   Use rofi to search the web.
# Usage:
#   web-search.sh
# -----------------------------------------------------------------------------
# Script:

declare -A URLS

URLS=(
	["github.com"]="https://github.com/search?ref=opensearch&q="
	["github_action"]="https://github.com/marketplace?type=actions&query="
	["github_user"]="https://github.com/scillidan?tab=repositories&q="
	["gist_user"]="https://gist.github.com/search?ref=searchresults&q=+user%3Ascillidan"
	["ipaddress.com"]="https://www.ipaddress.com/website/"
	["dmns.app"]="https://dmns.app/domains?q="
	["allacronyms.com"]="https://www.allacronyms.com/aa-searchme?q="
	["alternativeto.net"]="https://alternativeto.net/browse/search/?q="
	["animegarden"]="https://gm-anime-garden.vercel.app/resources/1?search="
	["ankiweb.net"]="https://ankiweb.net/shared/addons?search="
	["apkpure.com"]="https://apkpure.com/search?q="
	["automa.site"]="https://www.automa.site/marketplace?search="
	["bilibili.com"]="https://search.bilibili.com/all?keyword="
	["cheatsheets.zip"]="https://cheatsheets.zip/?q="
	["ctan.org"]="https://www.ctan.org/search?phrase="
	["devdocs.io"]="https://devdocs.io/#q="
	["douban.com"]="https://www.douban.com/search?q="
	["wordnik.com"]="https://www.wordnik.com/words/"
	["etymonline.com"]="https://www.etymonline.com/search?q="
	["aur.archlinux.org"]="https://aur.archlinux.org/packages?O=0&SeB=nd&outdated=&SB=p&SO=d&PP=50&submit=Go&K="
	["fdroid.org"]="https://search.f-droid.org/?q="
	["filehippo.com"]="https://filehippo.com/search/?q="
	["flathub.org"]="https://flathub.org/apps/search?q="
	["flickr.com"]="https://www.flickr.com/search/?license=2%2C3%2C4%2C5%2C6%2C9&text="
	["google.com"]="https://www.google.com/search?q="
	["hn.algolia.com"]="https://hn.algolia.com/?dateRange=all&page=0&prefix=false&sort=byPopularity&type=story&query="
	["hub.docker.com"]="https://hub.docker.com/search?q="
	["imdb.com"]="https://www.imdb.com/find?q="
	["jackett"]="http://ubuntu22:9117/UI/Dashboard#filter=all&search="
	["javascripting.com"]="https://www.javascripting.com/search?q="
	["jsdelivr.com"]="https://www.jsdelivr.com/?query="
	["lib.rs"]="https://lib.rs/search?q="
	["marketplace.visualstudio.com"]="https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Relevance&term="
	["nyaa.si"]="https://nyaa.si/?f=0&c=3_0&q="
	["ollama.com"]="https://ollama.com/library?q="
	["open-vsx.org"]="https://open-vsx.org/?sortBy=relevance&sortOrder=desc&search="
	["opensubtitles.org"]="https://www.opensubtitles.org/en/search2/sublanguageid-chi,eng/moviename-"
	["scira.ai"]="https://scira.ai/?query="
	["perplexity.ai"]="https://www.perplexity.ai/?q="
	["subhd.tv"]="https://subhd.tv/search/"
	["youtube.com"]="https://www.youtube.com/results?search_query="
	["emojikeyboard.io"]="https://emojikeyboard.io/search?query="
	["msys2.org"]="https://packages.msys2.org/search?q="
	# ["yomitan"]="chrome-extension://likgccmbimhjbgkjambclfkhldnlhbnn/search.html?query="
	# ["linkding"]="http://127.0.0.1:8060/bookmarks?q="
)

# List for rofi
gen_list() {
	for i in "${!URLS[@]}"; do
		echo "$i"
	done
}

main() {
	# Pass the list to rofi
	platform=$( (gen_list) | rofi -dmenu -matching fuzzy -no-custom -location 0 -p "Search > ")

	if [[ -n "$platform" ]]; then
		query=$( (echo) | rofi -dmenu -matching fuzzy -location 0 -p "Query > ")

		if [[ -n "$query" ]]; then
			url=${URLS[$platform]}$query
			xdg-open "$url"
		else
			exit
		fi

	else
		exit
	fi
}

main

exit 0
