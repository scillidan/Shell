#!/bin/bash

GOLDENDICT_DATA="$HOME/<path_to>"
GOLDENDICT_HOME="$HOME/<path_to>"
GOLDENDICT_CONF="$HOME/Usr/Git/dotfiles/.config/_goldendict"
GOLDENDICT_SRC="$HOME/Usr/Source/goldendict"
GOLDENDICT_DL="$HOME/Usr/Download/goldendict"

rm -rf "$GOLDENDICT_HOME/extras"
rm -rf "$GOLDENDICT_HOME/icons"
rm -rf "$GOLDENDICT_DATA/fonts"
rm -rf "$GOLDENDICT_DATA/styles"

ln -s "$GOLDENDICT_SRC/GoldenDict-Full-Dark-Theme/GoldenDict/extras" "$GOLDENDICT_HOME/extras"
ln -s "$GOLDENDICT_SRC/GoldenDict-Full-Dark-Theme/GoldenDict/icons" "$GOLDENDICT_HOME/icons"
ln -s "$GOLDENDICT_SRC/GoldenDict-Full-Dark-Theme/GoldenDict/fonts" "$GOLDENDICT_DATA/fonts"

mkdir -p "$GOLDENDICT_DATA/styles/Dark"
cat "$GOLDENDICT_SRC/GoldenDict-Full-Dark-Theme/GoldenDict/styles/Dark/article-style.css" "$GOLDENDICT_CONF/article-style_user.css" > "$GOLDENDICT_DATA/styles/Dark/article-style.css"

ln -s "$GOLDENDICT_SRC/GoldenDict-Full-Dark-Theme/GoldenDict/styles/Dark/qt-style.css" "$GOLDENDICT_DATA/styles/Dark/qt-style.css"
cp "$GOLDENDICT_CONF/config" "$GOLDENDICT_CONF/config.linkfile"
ln -s "$GOLDENDICT_CONF/config.linkfile" "$GOLDENDICT_DATA/config"

rm -rf "$GOLDENDICT_HOME/content"
mkdir -p "$GOLDENDICT_HOME/content"

ln -s "$GOLDENDICT_DL/morphology" "$GOLDENDICT_HOME/content/morphology"
ln -s "$GOLDENDICT_DL/mdx" "$GOLDENDICT_HOME/content/mdx"
ln -s "$GOLDENDICT_DL/stardict" "$GOLDENDICT_HOME/content/stardict"
mkdir -p "$GOLDENDICT_HOME/content/sound-dirs"
ln -s "$GOLDENDICT_DL/sound-dirs/Forvo_pron" "$GOLDENDICT_HOME/content/sound-dirs/Forvo_pron"
ln -s "$GOLDENDICT_DL/sound-dirs/pronunciations-en.zips" "$GOLDENDICT_HOME/content/sound-dirs/pronunciations-en.zips"
ln -s "$GOLDENDICT_DL/sound-dirs/kokoro-tts_etymonline.zips" "$GOLDENDICT_HOME/content/sound-dirs/kokoro-tts_etymonline.zips"

FORVO_PRON="$GOLDENDICT_DL/sound-dirs/Forvo_pron"
FORVO_OPUS="$GOLDENDICT_DL/sound-dirs/Forvo_pronunciations/export/opus"
FORVO_DSL="$GOLDENDICT_DL/sound-dirs/ForvoDSL/ForvoDSL-20220513"

rm -rf "$FORVO_PRON"
mkdir -p "$FORVO_PRON"

for lang in Afrikaans Albanian AncientGreek Arabic Armenian Azerbaijani Basque Belarusian Bengali Breton Bulgarian Cantonese Catalan Croatian Czech Danish Dutch English Esperanto Estonian Finnish French Frisian Gan Georgian German Greek Hakka Hebrew Hindi Hungarian Icelandic Indonesian Irish Italian Japanese Jin Kazakh Korean Latin Latvian Lithuanian Luxembourgish Malay Mandarin MinDong MinNan Mongolian Nahuatl Norwegian Persian Polish Portuguese Punjabi Romanian Russian Sanskrit Scots ScottishGaelic Serbian Slovak Slovenian SouthwesternMandarin Spanish Swahili Swedish Tagalog Tamil Tatar Thai ToisaneseCantonese Turkish Ukrainian Urdu Uyghur Uzbek Vietnamese Welsh Wu Xiang Yiddish Zhuang; do
    ln -s "$FORVO_DSL/Forvo$lang.dsl" "$FORVO_PRON/Forvo$lang.dsl"
done

for lang in Afrikaans Albanian AncientGreek Arabic Armenian Azerbaijani Basque Belarusian Bengali Breton Bulgarian Cantonese Catalan Croatian Czech Danish Dutch English Esperanto Estonian Finnish French Frisian Gan Georgian German Greek Hakka Hebrew Hindi Hungarian Icelandic Indonesian Irish Italian Japanese Jin Kazakh Korean Latin Latvian Lithuanian Luxembourgish Malay Mandarin MinDong MinNan Mongolian Nahuatl Norwegian Persian Polish Portuguese Punjabi Romanian Russian Sanskrit Scots ScottishGaelic Serbian Slovak Slovenian SouthwesternMandarin Spanish Swahili Swedish Tagalog Tamil Tatar Thai ToisaneseCantonese Turkish Ukrainian Urdu Uyghur Uzbek Vietnamese Welsh Wu Xiang Yiddish Zhuang; do
    ln -s "$FORVO_OPUS/${lang,,}.zip" "$FORVO_PRON/Forvo$lang.dsl.files.zip"
done

echo "Script executed successfully."