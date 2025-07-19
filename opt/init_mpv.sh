#!/bin/bash

set -e

MPV_DOTDIR="$HOME/.config/mpv"
MPV_CONF="$HOME/Usr/Git/dotfiles/.config/mpv"
MPV_SRC="$HOME/Usr/Source/mpv"
MPV_DL="$HOME/Usr/Download/mpv"

MPVC_VIDEO="$MPV_CONF/mpvc_video"
MPVC_MANGA="$MPV_CONF/mpvc_manga"
MPVC_MUSIC="$MPV_CONF/mpvc_music"
MPVC_ALL="$MPV_GLOBAL $MPVC_VIDEO $MPVC_MANGA $MPVC_MUSIC"

for d in $MPVC_ALL; do
    rm -rf "$d"
    mkdir -p "$d/fonts" "$d/scripts" "$d/script-modules" "$d/script-opts" "$d/shaders" "$d/watch_later"
done

INCLUDE="$MPV_CONF/include"
cat "$INCLUDE/global.conf" "$INCLUDE/video.conf" > "$MPVC_VIDEO/mpv.conf"
cat "$INCLUDE/global.conf" "$INCLUDE/music.conf" > "$MPVC_MUSIC/mpv.conf"
cat "$INCLUDE/global.conf" "$INCLUDE/manga.conf" > "$MPVC_MANGA/mpv.conf"

INPUT="$MPV_CONF/input"
cat "$INPUT/global.conf" "$INPUT/video.conf" > "$MPVC_VIDEO/input.conf"
cat "$INPUT/global.conf" "$INPUT/music.conf" > "$MPVC_MUSIC/input.conf"
cat "$INPUT/global.conf" "$INPUT/manga.conf" > "$MPVC_MANGA/input.conf"

CONFIG_GLOBAL="$MPVC_VIDEO $MPVC_MUSIC $MPVC_MANGA"
for d in $CONFIG_GLOBAL; do
    # 1. Get `uosc.zip` from [Releases](https://github.com/tomasklaen/uosc/releases).
    # 2. Decompress to `uosc/`.
    # 3. Install `uosc/fonts/*.ttf`.
    ln -s "$MPV_DL/uosc/scripts/uosc" "$d/scripts/uosc"

    # git clone --depth=1 https://github.com/po5/thumbfast
    ln -s "$MPV_SRC/thumbfast/thumbfast.lua" "$d/scripts/thumbfast.lua"
    ln -s "$MPV_SRC/thumbfast/thumbfast.conf" "$d/script-opts/thumbfast.conf"

    # 1. Get `HDR-Toys.zip` from [Releases](https://github.com/natural-harmonia-gropius/hdr-toys/releases)
    # 2. Decompress to `hdr-toys/`.
    ln -s "$MPV_SRC/hdr-toys/shaders/hdr-toys" "$d/shaders/hdr-toys"
    ln -s "$MPV_DL/hdr-toys/scripts/hdr-toys-helper.lua" "$d/scripts/hdr-toys-helper.lua"
    cat "$MPV_DL/hdr-toys/hdr-toys.conf" >> "$d/mpv.conf"

    # git clone --depth=1 https://github.com/hhirtz/mpv-retro-shaders
    ln -s "$MPV_SRC/mpv-retro-shaders" "$d/shaders/mpv-retro-shaders"
    cat "$MPV_SRC/mpv-retro-shaders/all.conf" >> "$d/mpv.conf"

    # git clone --depth=1 https://github.com/he2a/mpv-scripts mpv-scripts@he2a
    ln -s "$MPV_SRC/mpv-scripts@he2a/scripts/sview.lua" "$d/scripts/sview.lua"

    echo "File"

    # git clone --depth=1 https://github.com/cogentredtester/mpv-scripts mpv-scripts@cogentredtester
    ln -s "$MPV_SRC/mpv-scripts@cogentredtester/editions-notification.lua" "$d/scripts/editions-notification.lua"

    # git clone --depth=1 https://github.com/Hill-98/mpv-config mpv-config@Hill-98
    ln -s "$MPV_SRC/mpv-config@Hill-98/scripts/format-filename.js" "$d/scripts/format-filename.js"

    # git clone --depth=1 https://github.com/jonniek/mpv-filenavigator
    ln -s "$MPV_SRC/mpv-filenavigator/navigator.lua" "$d/scripts/navigator.lua"
    ln -s "$MPV_CONF/scripts/navigator.lua" "$d/script-opts/navigator.conf"

    # git clone --depth=1 https://github.com/jonniek/mpv-playlistmanager
    ln -s "$MPV_SRC/mpv-playlistmanager/playlistmanager.lua" "$d/scripts/playlistmanager.lua"
    ln -s "$MPV_SRC/mpv-playlistmanager/playlistmanager-save-interactive.lua" "$d/scripts/playlistmanager-save-interactive.lua"
    # copy "$MPV_SRC/mpv-playlistmanager/playlistmanager.conf" "$MPV_CONF/script-opts/playlistmanager.conf"
    ln -s "$MPV_CONF/script-opts/playlistmanager.conf" "$d/script-opts/playlistmanager.conf"

    # git clone --depth=1 https://github.com/sibwaf/mpv-scripts mpv-scripts@sibwaf
    ln -s "$MPV_SRC/mpv-scripts@sibwaf/fuzzydir.lua" "$d/scripts/fuzzydir.lua"
    ln -s "$MPV_SRC/mpv-scripts@sibwaf/reload.lua" "$d/scripts/reload.lua"

    # git clone --depth=1 https://github.com/zenyd/mpv-scripts mpv-scripts@zenyd
    ln -s "$MPV_SRC/mpv-scripts@zenyd/delete_file.lua" "$d/scripts/delete_file.lua"
    ln -s "$MPV_CONF/script-opts/delete_file.conf" "$d/script-opts/delete_file.conf"

    # git clone --depth=1 https://github.com/Kayizoku/mpv-rename
    ln -s "$MPV_SRC/mpv-rename/Rename.lua" "$d/scripts/Rename.lua"

    # git clone --depth=1 https://github.com/ayghub/open-dir
    ln -s "$MPV_SRC/open-dir/open-dir.lua" "$d/scripts/open-dir.lua"

    echo "Playback"

    # Get `auto-save-state.lua` from [AN3223/dotfiles](https://github.com/AN3223/dotfiles/blob/master/.config/mpv/scripts/auto-save-state.lua).
    ln -s "$MPV_DL/auto-save-state.lua" "$d/scripts/auto-save-state.lua"

    # git clone --depth=1 https://github.com/po5/celebi
    ln -s "$MPV_SRC/celebi/celebi.lua" "$d/scripts/celebi.lua"
    # copy "$MPV_SRC/celebi/celebi.conf" "$MPV_CONF/script-opts/celebi.conf"
    ln -s "$MPV_CONF/script-opts/celebi.conf" "$d/script-opts/celebi.conf"

    # git clone --depth=1 https://github.com/po5/memo
    ln -s "$MPV_SRC/memo/memo.lua" "$d/scripts/memo.lua"
    # copy "$MPV_SRC/memo/memo.conf" "$MPV_CONF/script-opts/memo.conf"
    ln -s "$MPV_CONF/script-opts/memo.conf" "$d/script-opts/memo.conf"

    # git clone --depth=1 https://github.com/sibwaf/mpv-scripts mpv-scripts@sibwaf
    ln -s "$MPV_SRC/mpv-scripts@sibwaf/blackout.lua" "$d/scripts/blackout.lua"

    # git clone --depth=1 https://github.com/zc62/mpv-scripts mpv-scripts@zc62
    ln -s "$MPV_SRC/mpv-scripts@zc62/autoloop.lua" "$d/scripts/autoloop.lua"
    ln -s "$MPV_SRC/mpv-scripts@zc62/exit-fullscreen.lua" "$d/scripts/exit-fullscreen.lua"

    # git clone --depth=1 https://github.com/wishyu/mpv-ontop-window
    ln -s "$MPV_SRC/mpv-ontop-window/ontop-window.lua" "$d/scripts/ontop-window.lua"

    # git clone --depth=1 https://github.com/gaesa/mpv-hold-accelerate
    # cd mpv-hold-accelerate
    # pnpm install --frozen-lockfile && pnpm run build
    # mklink "%%d/scripts/hold_accelerate.js" "$MPV_DL/mpv-hold-accelerate/hold_accelerate.js"
    ln -s "$MPV_SRC/mpv-hold-accelerate/dist/hold_accelerate.js" "$d/scripts/hold_accelerate.js"
    ln -s "$MPV_CONF/script-opts/hold_accelerate.conf" "$d/script-opts/hold_accelerate.conf"

    # git clone --depth=1 https://github.com/mpv-player/mpv
    ln -s "$MPV_SRC/mpv/TOOLS/lua/ontop-playback.lua" "$d/scripts/ontop-playback.lua"

    echo "Chapter"

    # git clone --depth=1 https://github.com/mar04/chapters_for_mpv
    ln -s "$MPV_SRC/chapters_for_mpv/chapters.lua" "$d/scripts/chapters.lua"

    # git clone --depth=1 https://github.com/zxhzxhz/mpv-chapters
    ln -s "$MPV_SRC/mpv-chapters/mpv_chapters.js" "$d/scripts/mpv_chapters.js"

    # git clone --depth=1 https://github.com/dyphire/mpv-scripts mpv-scripts@dyphire
    ln -s "$MPV_SRC/mpv-scripts@dyphire/chapter-make-read.lua" "$d/scripts/chapter-make-read.lua"

    echo "Subtitle"

    # git clone --depth=1 https://github.com/pierretom/autoselect-forced-sub
    ln -s "$MPV_SRC/autoselect-forced-sub/autoselect-forced-sub.lua" "$d/scripts/autoselect-forced-sub.lua"
    # copy "$MPV_SRC/autoselect-forced-sub/afs.conf" "$MPV_CONF/script-opts/afs.conf"
    ln -s "$MPV_CONF/script-opts/afs.conf" "$d/script-opts/afs.conf"

    # git clone --depth=1 https://github.com/joaquintorres/autosubsync-mpv
    ln -s "$MPV_SRC/autosubsync-mpv" "$d/scripts/autosubsync-mpv"
    ln -s "$MPV_CONF/script-opts/autosubsync.conf" "$d/script-opts/autosubsync.conf"

    # git clone --depth=1 https://github.com/zenwarr/mpv-config mpv-config@zenwarr
    ln -s "$MPV_SRC/mpv-config@zenwarr/scripts/restore-subtitles.lua" "$d/scripts/restore-subtitles.lua"

    # git clone --depth=1 https://github.com/magnum357i/mpv-dualsubtitles
    ln -s "$MPV_SRC/mpv-dualsubtitles/dualsubtitles.lua" "$d/scripts/dualsubtitles.lua"
    ln -s "$MPV_CONF/script-opts/dualsubtitles.conf" "$d/script-opts/dualsubtitles.conf"

    # git clone --depth=1 https://github.com/liberlanco/mpv-lang-learner
    ln -s "$MPV_SRC/mpv-lang-learner/lang-learner.lua" "$d/scripts/lang-learner.lua"
    # copy "$MPV_SRC/mpv-lang-learner/lang-learner.conf" "%%d/scripts/lang-learner.conf"
    ln -s "$MPV_CONF/script-opts/lang-learner.conf" "$d/script-opts/lang-learner.conf"

    # git clone --depth=1 https://github.com/dyphire/mpv-scripts mpv-scripts@dyphire
    ln -s "$MPV_SRC/mpv-scripts@dyphire/sub_export.lua" "$d/scripts/sub_export.lua"

    # git clone --depth=1 https://github.com/directorscut82/find_subtitles
    # copy "$MPV_SRC/find_subtitles/find_subtitles.lua" "$d/%MPV_CONF/scripts/find_subtitles.lua"
    ln -s "$MPV_CONF/scripts/find_subtitles.lua" "$d/scripts/find_subtitles.lua"

    # git clone --depth=1 https://github.com/pzim-devdata/mpv-scripts mpv-scripts@pzim-devdata
    ln -s "$MPV_SRC/mpv-scripts@pzim-devdata/mpv-sub_not_forced_not_sdh.lua" "$d/scripts/mpv-sub_not_forced_not_sdh.lua"

    # git clone --depth=1 https://github.com/genfu94/mpv-subtitle-retimer
    ln -s "$MPV_SRC/mpv-subtitle-retimer/src" "$d/scripts/mpv-subtitle-retimer"

    # git clone --depth=1 https://github.com/christoph-heinrich/mpv-subtitle-lines
    ln -s "$MPV_SRC/mpv-subtitle-lines/subtitle-lines.lua" "$d/scripts/subtitle-lines.lua"

    echo "Stream"

    # git clone --depth=1 https://github.com/mpv-player/mpv
    ln -s "$MPV_SRC/mpv/TOOLS/lua/autoload.lua" "$d/scripts/autoload.lua"
    ln -s "$MPV_CONF/script-opts/autoload.conf" "$d/script-opts/autoload.conf"

    # git clone --depth=1 https://github.com/christoph-heinrich/mpv-quality-menu
    ln -s "$MPV_SRC/mpv-quality-menu/quality-menu.lua" "$d/scripts/quality-menu.lua"
    ln -s "$MPV_SRC/mpv-quality-menu/quality-menu.conf" "$d/script-opts/quality-menu.conf"

    # git clone --depth=1 https://github.com/jonniek/mpv-scripts mpv-scripts@jonniek
    ln -s "$MPV_SRC/mpv-scripts@jonniek/appendURL.lua" "$d/scripts/appendURL.lua"

    # git clone --depth=1 https://github.com/mrxdst/webtorrent-mpv-hook
    ln -s "$MPV_SRC/webtorrent-mpv-hook/build/webtorrent.js" "$d/scripts/webtorrent.js"
    ln -s "$MPV_CONF/script-opts/webtorrent.conf" "$d/script-opts/webtorrent.conf"

    echo "Other"

    # git clone --depth=1 https://github.com/natural-harmonia-gropius/input-event
    ln -s "$MPV_SRC/input-event/inputevent.lua" "$d/scripts/inputevent.lua"

    # git clone --depth=1 https://github.com/CogentRedTester/mpv-scroll-list
    ln -s "$MPV_SRC/mpv-scroll-list/scroll-list.lua" "$d/script-modules/scroll-list.lua"

    # git clone --depth=1 https://github.com/CogentRedTester/mpv-search-page
    ln -s "$MPV_SRC/mpv-search-page/search-page.lua" "$d/scripts/search-page.lua"
    # copy "$MPV_SRC/mpv-search-page/search_page.conf" "$MPV_CONF/script-opts/search_page.conf"
    ln -s "$MPV_CONF/script-opts/search_page.conf" "$d/script-opts/search_page.conf"

    # git clone --depth=1 https://github.com/shadax1/mpv_segment_length
    ln -s "$MPV_SRC/mpv_segment_length/mpv_segment_length.lua" "$d/scripts/mpv_segment_length.lua"

    # git clone --depth=1 https://github.com/cogentredtester/mpv-scripts mpv-scripts@cogentredtester
    ln -s "$MPV_SRC/mpv-scripts@cogentredtester/show-errors.lua" "$d/scripts/show-errors.lua"

    # git clone --depth=1 https://github.com/CogentRedTester/mpv-user-input
    ln -s "$MPV_SRC/mpv-user-input/user-input.lua" "$d/scripts/user-input.lua"
    ln -s "$MPV_SRC/mpv-user-input/user-input-module.lua" "$d/script-modules/user-input-module.lua"
done

for d in $MPVC_VIDEO; do
    # git clone --depth=1 https://github.com/ento/mpv-cheatsheet
    # mkdir dist
    # browserify --bare src/index.js > dist/cheatsheet.js
    # copy "$MPV_SRC/mpv-cheatsheet/dist/cheatsheet.js" "$MPV_CONF/scripts/cheatsheet.js"
    ln -s "$MPV_CONF/scripts/cheatsheet_video.js" "$d/scripts/cheatsheet.js"

    # git clone --depth=1 https://github.com/Seme4eg/mpv-scripts mpv-scripts@Seme4eg
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/script-modules/extended-menu.lua" "$d/script-modules/extended-menu.lua"
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/M-x.lua" "$d/scripts/M-x.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/script-opts/M_x.conf" "$MPV_CONF/script-opts/M_x.conf"
    ln -s "$MPV_CONF/script-opts/M_x.conf" "$d/script-opts/M_x.conf"
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/script-modules/leader.lua" "$d/script-modules/leader.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/leader.lua" "$MPV_CONF/scripts/leader.lua"
    ln -s "$MPV_CONF/scripts/leader_video.lua" "$d/scripts/leader.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/script-opts/leader.conf" "$MPV_CONF/script-opts/leader.conf"
    ln -s "$MPV_CONF/script-opts/leader.conf" "$d/script-opts/leader.conf"

    # git clone --depth=1 https://github.com/ctlaltdefeat/mpv-open-imdb-page
    ln -s "$MPV_SRC/mpv-open-imdb-page" "$d/scripts/mpv-open-imdb-page"

    # git clone --depth=1 https://github.com/ben-kerman/mpv-sub-scripts
    ln -s "$MPV_SRC/mpv-sub-scripts/sub-pause.lua" "$d/scripts/sub-pause.lua"
    ln -s "$MPV_CONF/script-opts/sub_pause.conf" "$d/script-opts/sub_pause.conf"
    ln -s "$MPV_SRC/mpv-sub-scripts/sub-skip.lua" "$d/scripts/sub-skip.lua"
    ln -s "$MPV_CONF/script-opts/sub_skip.conf" "$d/script-opts/sub_skip.conf"
done

echo "music config"

for d in $MPVC_MUSIC; do
    ln -s "$MPV_CONF/scripts/cheatsheet_music.js" "$d/scripts/cheatsheet.js"

    # git clone --depth=1 https://github.com/Seme4eg/mpv-scripts mpv-scripts@Seme4eg
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/script-modules/extended-menu.lua" "$d/script-modules/extended-menu.lua"
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/M-x.lua" "$d/scripts/M-x.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/script-opts/M_x.conf" "$MPV_CONF/script-opts/M_x.conf"
    ln -s "$MPV_CONF/script-opts/M_x.conf" "$d/script-opts/M_x.conf"
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/script-modules/leader.lua" "$d/script-modules/leader.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/leader.lua" "$MPV_CONF/scripts/leader.lua"
    ln -s "$MPV_CONF/scripts/leader_music.lua" "$d/scripts/leader.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/script-opts/leader.conf" "$MPV_CONF/script-opts/leader.conf"
    ln -s "$MPV_CONF/script-opts/leader.conf" "$d/script-opts/leader.conf"

    # git clone --depth=1 https://github.com/thinkmcflythink/mpv-loudnorm
    ln -s "$MPV_SRC/mpv-loudnorm" "$d/scripts/real_loudnorm"

    # git clone --depth=1 https://github.com/cogentredtester/mpv-coverart
    ln -s "$MPV_SRC/mpv-coverart/coverart.lua" "$d/scripts/coverart.lua"
    # copy "$MPV_SRC/mpv-coverart/coverart.conf" "$MPV_CONF/script-opts/coverart.conf"
    ln -s "$MPV_CONF/script-opts/coverart.conf" "$d/script-opts/coverart.conf"

    # git clone --depth=1 https://github.com/cogentredtester/mpv-scripts mpv-scripts@cogentredtester
    ln -s "$MPV_SRC/mpv-scripts@cogentredtester/save-playlist.lua" "$d/scripts/save-playlist.lua"

    # git clone --depth=1 https://github.com/stax76/mpv-scripts mpv-scripts@stax76
    ln -s "$MPV_SRC/mpv-scripts@stax76/smart_volume.lua" "$d/scripts/smart_volume.lua"
done

CONFIG_DIR_MANGA="$MPVC_MANGA"
for d in $CONFIG_DIR_MANGA; do
    ln -s "$MPV_CONF/scripts/cheatsheet_manga.js" "$d/scripts/cheatsheet.js"

    # git clone --depth=1 https://github.com/Seme4eg/mpv-scripts mpv-scripts@Seme4eg
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/script-modules/extended-menu.lua" "$d/script-modules/extended-menu.lua"
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/M-x.lua" "$d/scripts/M-x.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/script-opts/M_x.conf" "$MPV_CONF/script-opts/M_x.conf"
    ln -s "$MPV_CONF/script-opts/M_x.conf" "$d/script-opts/M_x.conf"
    ln -s "$MPV_SRC/mpv-scripts@Seme4eg/script-modules/leader.lua" "$d/script-modules/leader.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/leader.lua" "$MPV_CONF/scripts/leader.lua"
    ln -s "$MPV_CONF/scripts/leader_manga.lua" "$d/scripts/leader.lua"
    # copy "$MPV_SRC/mpv-scripts@Seme4eg/script-opts/leader.conf" "$MPV_CONF/script-opts/leader.conf"
    ln -s "$MPV_CONF/script-opts/leader.conf" "$d/script-opts/leader.conf"

    # git clone --depth=1 https://github.com/occivink/mpv-gallery-view
    ln -s "$MPV_SRC/mpv-gallery-view/script-modules/gallery.lua" "$d/script-modules/gallery.lua"
    ln -s "$MPV_SRC/mpv-gallery-view/scripts/gallery-thumbgen.lua" "$d/scripts/gallery-thumbgen.lua"
    ln -s "$MPV_SRC/mpv-gallery-view/scripts/playlist-view.lua" "$d/scripts/playlist-view.lua"
    # copy "$MPV_SRC/mpv-gallery-view/script-opts/playlist_view.conf" "$MPV_CONF/script-opts/playlist_view.conf"
    ln -s "$MPV_CONF/script-opts/playlist_view.conf" "$d/script-opts/playlist_view.conf"

    # git clone --depth=1 https://github.com/guidocella/mpv-image-config
    ln -s "$MPV_SRC/mpv-image-config/scripts/align-images.lua" "$d/scripts/align-images.lua"
    ln -s "$MPV_SRC/mpv-image-config/scripts/image-bindings.lua" "$d/scripts/image-bindings.lua"
    # copy "$MPV_SRC/mpv-image-config/script-opts/align_images.conf" "$MPV_CONF/script-opts/align_images.conf"
    # copy "$MPV_SRC/mpv-image-config/script-opts/image_bindings.conf" "$MPV_CONF/script-opts/image_bindings.conf"
    ln -s "$MPV_CONF/script-opts/align_images.conf" "$d/script-opts/align_images.conf"
    ln -s "$MPV_CONF/script-opts/image_bindings.conf" "$d/script-opts/image_bindings.conf"
    cat "$MPV_SRC/mpv-image-config/mpv.conf" >> "$d/mpv.conf"
    cat "$MPV_SRC/mpv-image-config/input.conf" >> "$d/input.conf"

    # git clone --depth=1 https://github.com/occivink/mpv-image-viewer
    ln -s "$MPV_SRC/mpv-image-viewer/scripts/freeze-window.lua" "$d/scripts/freeze-window.lua"
    ln -s "$MPV_SRC/mpv-image-viewer/scripts/image-positioning.lua" "$d/scripts/image-positioning.lua"
    ln -s "$MPV_SRC/mpv-image-viewer/scripts/minimap.lua" "$d/scripts/minimap.lua"
    ln -s "$MPV_SRC/mpv-image-viewer/scripts/status-line.lua" "$d/scripts/status-line.lua"
    ln -s "$MPV_SRC/mpv-image-viewer/scripts/detect-image.lua" "$d/scripts/detect-image.lua"
    # copy "$MPV_SRC/mpv-image-viewer/script-opts/image_positioning.conf" "$MPV_CONF/script-opts/image_positioning.conf"
    # copy "$MPV_SRC/mpv-image-viewer/script-opts/minimap.conf" "$MPV_CONF/script-opts/minimap.conf"
    # copy "$MPV_SRC/mpv-image-viewer/script-opts/status_line.conf" "$MPV_CONF/script-opts/status_line.conf"
    # copy "$MPV_SRC/mpv-image-viewer/script-opts/detect_image.conf" "$MPV_CONF/script-opts/detect_image.conf"
    ln -s "$MPV_CONF/script-opts/image_positioning.conf" "$d/script-opts/image_positioning.conf"
    ln -s "$MPV_CONF/script-opts/minimap.conf" "$d/script-opts/minimap.conf"
    ln -s "$MPV_CONF/script-opts/status_line.conf" "$d/script-opts/status_line.conf"
    ln -s "$MPV_CONF/script-opts/detect_image.conf" "$d/script-opts/detect_image.conf"

    # git clone --depth=1 https://github.com/dudemanguy/mpv-manga-reader
    ln -s "$MPV_SRC/mpv-manga-reader/manga-reader.lua" "$d/scripts/manga-reader.lua"

    # git clone --depth=1 https://github.com/jonniek/mpv-nextfile
    ln -s "$MPV_SRC/mpv-nextfile/nextfile.lua" "$d/scripts/nextfile.lua"
done

rm -rf "$MPV_DOTDIR"
mkdir -p "$MPV_DOTDIR"
fastcopy /open_window /auto_close "$MPVC_VIDEO" /to="$MPV_DOTDIR"
echo

read -p "Press Enter to continue..."