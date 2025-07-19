@echo off

setlocal

set "MPV_DATA=%SCOOP_HOME%\apps\mpv\current\portable_config"
set "MPV_CONF=%USERPROFILE%\Usr\Git\dotfiles\.config\mpv"
set "MPV_SRC=%USERPROFILE%\Usr\Source\mpv"
set "MPV_DL=%USERPROFILE%\Usr\Download\mpv"

set "MPVC_VIDEO=%MPV_CONF%\mpvc_video"
set "MPVC_MANGA=%MPV_CONF%\mpvc_manga"
set "MPVC_MUSIC=%MPV_CONF%\mpvc_music"
set "MPVC_ALL=%MPVC_GLOBAL% %MPVC_VIDEO% %MPVC_MANGA% %MPVC_MUSIC%"
for %%d in (%MPVC_ALL%) do (
    rmdir /S /Q "%%d"
    mkdir "%%d"
    mkdir "%%d\fonts"
    mkdir "%%d\scripts"
    mkdir "%%d\script-modules"
    mkdir "%%d\script-opts"
    mkdir "%%d\shaders"
    mkdir "%%d\watch_later"
)

set "INCLUDE=%MPV_CONF%\include"
type "%INCLUDE%\global.conf" "%INCLUDE%\video.conf" > "%MPVC_VIDEO%\mpv.conf"
type "%INCLUDE%\global.conf" "%INCLUDE%\music.conf" > "%MPVC_MUSIC%\mpv.conf"
type "%INCLUDE%\global.conf" "%INCLUDE%\manga.conf" > "%MPVC_MANGA%\mpv.conf"

set "INPUT=%MPV_CONF%\input"
type "%INPUT%\global.conf" "%INPUT%\video.conf" > "%MPVC_VIDEO%\input.conf"
type "%INPUT%\global.conf" "%INPUT%\music.conf" > "%MPVC_MUSIC%\input.conf"
type "%INPUT%\global.conf" "%INPUT%\manga.conf" > "%MPVC_MANGA%\input.conf"

set "CONFIG_GLOBAL=%MPVC_VIDEO% %MPVC_MUSIC% %MPVC_MANGA%"
for %%d in (%CONFIG_GLOBAL%) do (
    rem 1. Get `uosc.zip` from [Releases](https://github.com/tomasklaen/uosc/releases).
    rem 2. Decompress to `uosc/`.
    rem 3. Install `uosc/fonts/*.ttf`.
    mklink /J "%%d\scripts\uosc" "%MPV_DL%\uosc\scripts\uosc"

    rem git clone --depth=1 https://github.com/po5/thumbfast
    mklink "%%d\scripts\thumbfast.lua" "%MPV_SRC%\thumbfast\thumbfast.lua"
    mklink "%%d\script-opts\thumbfast.conf" "%MPV_SRC%\thumbfast\thumbfast.conf"

    rem 1. Get `HDR-Toys.zip` from [Releases](https://github.com/natural-harmonia-gropius/hdr-toys/releases)
    rem 2. Decompress to `hdr-toys/`.
    mklink /J "%%d\shaders\hdr-toys" "%MPV_SRC%\hdr-toys\shaders\hdr-toys"
    mklink "%%d\scripts\hdr-toys-helper.lua" "%MPV_DL%\hdr-toys\scripts\hdr-toys-helper.lua"
    type "%MPV_DL%\hdr-toys\hdr-toys.conf" >> "%%d\mpv.conf"

    rem git clone --depth=1 https://github.com/hhirtz/mpv-retro-shaders
    mklink /J "%%d\shaders\mpv-retro-shaders" "%MPV_SRC%\mpv-retro-shaders"
    type "%MPV_SRC%\mpv-retro-shaders\all.conf" >> "%%d\mpv.conf"

    rem git clone --depth=1 https://github.com/he2a/mpv-scripts mpv-scripts@he2a
    mklink "%%d\scripts\sview.lua" "%MPV_SRC%\mpv-scripts@he2a\scripts\sview.lua"

    echo File

    rem git clone --depth=1 https://github.com/cogentredtester/mpv-scripts mpv-scripts@cogentredtester
    mklink "%%d\scripts\editions-notification.lua" "%MPV_SRC%\mpv-scripts@cogentredtester\editions-notification.lua"

    rem git clone --depth=1 https://github.com/Hill-98/mpv-config mpv-config@Hill-98
    mklink "%%d\scripts\format-filename.js" "%MPV_SRC%\mpv-config@Hill-98\scripts\format-filename.js"

    rem git clone --depth=1 https://github.com/jonniek/mpv-filenavigator
    mklink "%%d\scripts\navigator.lua" "%MPV_SRC%\mpv-filenavigator\navigator.lua"
    rem mklink "%%d\scripts\navigator.lua" "%MPV_CONF%\scripts\navigator.lua"
    mklink "%%d\script-opts\navigator.conf" "%MPV_CONF%\script-opts\navigator.conf"

    rem git clone --depth=1 https://github.com/jonniek/mpv-playlistmanager
    mklink "%%d\scripts\playlistmanager.lua" "%MPV_SRC%\mpv-playlistmanager\playlistmanager.lua"
    mklink "%%d\scripts\playlistmanager-save-interactive.lua" "%MPV_SRC%\mpv-playlistmanager\playlistmanager-save-interactive.lua"
    :: copy "%MPV_SRC%\mpv-playlistmanager\playlistmanager.conf" "%MPV_CONF%\script-optsplaylistmanager.conf"
    mklink "%%d\script-opts\playlistmanager.conf" "%MPV_CONF%\script-opts\playlistmanager.conf"

    rem git clone --depth=1 https://github.com/sibwaf/mpv-scripts mpv-scripts@sibwaf
    mklink "%%d\scripts\fuzzydir.lua" "%MPV_SRC%\mpv-scripts@sibwaf\fuzzydir.lua"
    mklink "%%d\scripts\reload.lua" "%MPV_SRC%\mpv-scripts@sibwaf\reload.lua"

    rem git clone --depth=1 https://github.com/zenyd/mpv-scripts mpv-scripts@zenyd
    mklink "%%d\scripts\delete_file.lua" "%MPV_SRC%\mpv-scripts@zenyd\delete_file.lua"
    mklink "%%d\script-opts\delete_file.conf" "%MPV_CONF%\script-opts\delete_file.conf"

    rem git clone --depth=1 https://github.com/Kayizoku/mpv-rename
    mklink "%%d\scripts\Rename.lua" "%MPV_SRC%\mpv-rename\Rename.lua"

    rem git clone --depth=1 https://github.com/ayghub/open-dir
    mklink "%%d\scripts\open-dir.lua" "%MPV_SRC%\open-dir\open-dir.lua"

    echo Playback

    rem Get `auto-save-state.lua` from [AN3223/dotfiles](https://github.com/AN3223/dotfiles/blob/master/.config/mpv/scripts/auto-save-state.lua).
    mklink "%%d\scripts\auto-save-state.lua" "%MPV_DL%\auto-save-state.lua"

    rem git clone --depth=1 https://github.com/po5/celebi
    mklink "%%d\scripts\celebi.lua" "%MPV_SRC%\celebi\celebi.lua"
    :: copy "%MPV_SRC%\celebi\celebi.conf" "%MPV_CONF%\script-opts\celebi.conf"
    mklink "%%d\script-opts\celebi.conf" "%MPV_CONF%\script-opts\celebi.conf"

    rem git clone --depth=1 https://github.com/po5/memo
    mklink "%%d\scripts\memo.lua" "%MPV_SRC%\memo\memo.lua"
    :: copy "%MPV_SRC%\memo\memo.conf" "%MPV_CONF%\script-opts\memo.conf"
    mklink "%%d\script-opts\memo.conf" "%MPV_CONF%\script-opts\memo.conf"

    rem git clone --depth=1 https://github.com/sibwaf/mpv-scripts mpv-scripts@sibwaf
    mklink "%%d\scripts\blackout.lua" "%MPV_SRC%\mpv-scripts@sibwaf\blackout.lua"

    rem git clone --depth=1 https://github.com/zc62/mpv-scripts mpv-scripts@zc62
    mklink "%%d\scripts\autoloop.lua" "%MPV_SRC%\mpv-scripts@zc62\autoloop.lua"
    mklink "%%d\scripts\exit-fullscreen.lua" "%MPV_SRC%\mpv-scripts@zc62\exit-fullscreen.lua"

    rem git clone --depth=1 https://github.com/wishyu/mpv-ontop-window
    mklink "%%d\scripts\ontop-window.lua" "%MPV_SRC%\mpv-ontop-window\ontop-window.lua"

    rem git clone --depth=1 https://github.com/gaesa/mpv-hold-accelerate
    rem cd mpv-hold-accelerate
    rem pnpm install --frozen-lockfile && pnpm run build
    :: mklink "%%d\scripts\hold_accelerate.js" "%MPV_DL%\mpv-hold-accelerate\hold_accelerate.js"
    mklink "%%d\scripts\hold_accelerate.js" "%MPV_SRC%\mpv-hold-accelerate\dist\hold_accelerate.js"
    mklink "%%d\script-opts\hold_accelerate.conf" "%MPV_CONF%\script-opts\hold_accelerate.conf"

    rem git clone --depth=1 https://github.com/mpv-player/mpv
    mklink "%%d\scripts\ontop-playback.lua" "%MPV_SRC%\mpv\TOOLS\lua\ontop-playback.lua"

    echo Chapter

    rem git clone --depth=1 https://github.com/mar04/chapters_for_mpv
    mklink "%%d\scripts\chapters.lua" "%MPV_SRC%\chapters_for_mpv\chapters.lua"

    rem git clone --depth=1 https://github.com/zxhzxhz/mpv-chapters
    mklink "%%d\scripts\mpv_chapters.js" "%MPV_SRC%\mpv-chapters\mpv_chapters.js"

    rem git clone --depth=1 https://github.com/dyphire/mpv-scripts mpv-scripts@dyphire
    mklink "%%d\scripts\chapter-make-read.lua" "%MPV_SRC%\mpv-scripts@dyphire\chapter-make-read.lua"

    echo Subtitle

    rem git clone --depth=1 https://github.com/pierretom/autoselect-forced-sub
    mklink "%%d\scripts\autoselect-forced-sub.lua" "%MPV_SRC%\autoselect-forced-sub\autoselect-forced-sub.lua"
    :: copy "%MPV_SRC%\autoselect-forced-sub\afs.conf" "%MPV_CONF%\script-opts\afs.conf"
    mklink "%%d\script-opts\afs.conf" "%MPV_CONF%\script-opts\afs.conf"

    rem git clone --depth=1 https://github.com/joaquintorres/autosubsync-mpv
    mklink /J "%%d\scripts\autosubsync-mpv" "%MPV_SRC%\autosubsync-mpv"
    mklink "%%d\script-opts\autosubsync.conf" "%MPV_CONF%\script-opts\autosubsync.conf"

    rem git clone --depth=1 https://github.com/zenwarr/mpv-config mpv-config@zenwarr
    mklink "%%d\scripts\restore-subtitles.lua" "%MPV_SRC%\mpv-config@zenwarr\scripts\restore-subtitles.lua"

    rem git clone --depth=1 https://github.com/magnum357i/mpv-dualsubtitles
    mklink "%%d\scripts\dualsubtitles.lua" "%MPV_SRC%\mpv-dualsubtitles\dualsubtitles.lua"
    mklink "%%d\script-opts\dualsubtitles.conf" "%MPV_CONF%\script-opts\dualsubtitles.conf"

    rem git clone --depth=1 https://github.com/liberlanco/mpv-lang-learner
    mklink "%%d\scripts\lang-learner.lua" "%MPV_SRC%\mpv-lang-learner\lang-learner.lua"
    :: copy "%MPV_SRC%\mpv-lang-learner\lang-learner.conf" "%%d\scripts\lang-learner.conf"
    mklink "%%d\script-opts\lang-learner.conf" "%MPV_CONF%\script-opts\lang-learner.conf"

    rem git clone --depth=1 https://github.com/dyphire/mpv-scripts mpv-scripts@dyphire
    mklink "%%d\scripts\sub_export.lua" "%MPV_SRC%\mpv-scripts@dyphire\sub_export.lua"

    rem git clone --depth=1 https://github.com/directorscut82/find_subtitles
    :: copy "%MPV_SRC%\find_subtitles\find_subtitles.lua" "%%d\%MPV_CONF%\scripts\find_subtitles.lua"
    mklink "%%d\scripts\find_subtitles.lua" "%MPV_CONF%\scripts\find_subtitles.lua"

    rem git clone --depth=1 https://github.com/pzim-devdata/mpv-scripts mpv-scripts@pzim-devdata
    mklink "%%d\scripts\mpv-sub_not_forced_not_sdh.lua" "%MPV_SRC%\mpv-scripts@pzim-devdata\mpv-sub_not_forced_not_sdh.lua"

    rem git clone --depth=1 https://github.com/genfu94/mpv-subtitle-retimer
    mklink /J "%%d\scripts\mpv-subtitle-retimer" "%MPV_SRC%\mpv-subtitle-retimer\src"

    rem git clone --depth=1 https://github.com/christoph-heinrich/mpv-subtitle-lines
    mklink "%%d\scripts\subtitle-lines.lua" "%MPV_SRC%\mpv-subtitle-lines\subtitle-lines.lua"

    echo Stream

    rem git clone --depth=1 https://github.com/mpv-player/mpv
    mklink "%%d\scripts\autoload.lua" "%MPV_SRC%\mpv\TOOLS\lua\autoload.lua"
    mklink "%%d\script-opts\autoload.conf" "%MPV_CONF%\script-opts\autoload.conf"

    rem git clone --depth=1 https://github.com/christoph-heinrich/mpv-quality-menu
    mklink "%%d\scripts\quality-menu.lua" "%MPV_SRC%\mpv-quality-menu\quality-menu.lua"
    mklink "%%d\script-opts\quality-menu.conf" "%MPV_SRC%\mpv-quality-menu\quality-menu.conf"

    rem git clone --depth=1 https://github.com/jonniek/mpv-scripts mpv-scripts@jonniek
    mklink "%%d\scripts\appendURL.lua" "%MPV_SRC%\mpv-scripts@jonniek\appendURL.lua"

    rem git clone --depth=1 https://github.com/mrxdst/webtorrent-mpv-hook
    mklink "%%d\scripts\webtorrent.js" "%MPV_SRC%\webtorrent-mpv-hook\build\webtorrent.js"
    mklink "%%d\script-opts\webtorrent.conf" "%MPV_CONF%\script-opts\webtorrent.conf"

    echo Other

    rem git clone --depth=1 https://github.com/natural-harmonia-gropius/input-event
    mklink "%%d\scripts\inputevent.lua" "%MPV_SRC%\input-event\inputevent.lua"

    rem git clone --depth=1 https://github.com/CogentRedTester/mpv-scroll-list
    mklink "%%d\script-modules\scroll-list.lua" "%MPV_SRC%\mpv-scroll-list\scroll-list.lua"

    rem git clone --depth=1 https://github.com/CogentRedTester/mpv-search-page
    mklink "%%d\scripts\search-page.lua" "%MPV_SRC%\mpv-search-page\search-page.lua"
    :: copy "%MPV_SRC%\mpv-search-page\search_page.conf" "%MPV_CONF%\script-opts\search_page.conf"
    mklink "%%d\script-opts\search_page.conf" "%MPV_CONF%\script-opts\search_page.conf"

    rem git clone --depth=1 https://github.com/shadax1/mpv_segment_length
    mklink "%%d\scripts\mpv_segment_length.lua" "%MPV_SRC%\mpv_segment_length\mpv_segment_length.lua"

    rem git clone --depth=1 https://github.com/cogentredtester/mpv-scripts mpv-scripts@cogentredtester
    mklink "%%d\scripts\show-errors.lua" "%MPV_SRC%\mpv-scripts@cogentredtester\show-errors.lua"

    rem git clone --depth=1 https://github.com/CogentRedTester/mpv-user-input
    mklink "%%d\scripts\user-input.lua" "%MPV_SRC%\mpv-user-input\user-input.lua"
    mklink "%%d\script-modules\user-input-module.lua" "%MPV_SRC%\mpv-user-input\user-input-module.lua"
)

for %%d in (%MPVC_VIDEO%) do (
    rem git clone --depth=1 https://github.com/ento/mpv-cheatsheet
    rem mkdir dist
    rem browserify --bare src/index.js > dist/cheatsheet.js
    :: copy "%MPV_SRC%\mpv-cheatsheet\dist\cheatsheet.js" "%MPV_CONF%\scripts\cheatsheet.js"
    mklink "%%d\scripts\cheatsheet.js" "%MPV_CONF%\scripts\cheatsheet_video.js"

    rem git clone --depth=1 https://github.com/Seme4eg/mpv-scripts mpv-scripts@Seme4eg
    mklink "%%d\script-modules\extended-menu.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\script-modules\extended-menu.lua"
    mklink "%%d\scripts\M-x.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\M-x.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\script-opts\M_x.conf" "%MPV_CONF%\script-opts\M_x.conf"
    mklink "%%d\script-opts\M_x.conf" "%MPV_CONF%\script-opts\M_x.conf"
    mklink "%%d\script-modules\leader.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\script-modules\leader.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\leader.lua" "%MPV_CONF%\scripts\leader.lua"
    mklink "%%d\scripts\leader.lua" "%MPV_CONF%\scripts\leader_video.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\script-opts\leader.conf" "%MPV_CONF%\script-opts\leader.conf"
    mklink "%%d\script-opts\leader.conf" "%MPV_CONF%\script-opts\leader.conf"

    rem git clone --depth=1 https://github.com/ctlaltdefeat/mpv-open-imdb-page
    mklink /J "%%d\scripts\mpv-open-imdb-page" "%MPV_SRC%\mpv-open-imdb-page"

    rem git clone --depth=1 https://github.com/ben-kerman/mpv-sub-scripts
    mklink "%%d\scripts\sub-pause.lua" "%MPV_SRC%\mpv-sub-scripts\sub-pause.lua"
    mklink "%%d\script-opts\sub_pause.conf" "%MPV_CONF%\script-opts\sub_pause.conf"
    mklink "%%d\scripts\sub-skip.lua" "%MPV_SRC%\mpv-sub-scripts\sub-skip.lua"
    mklink "%%d\script-opts\sub_skip.conf" "%MPV_CONF%\script-opts\sub_skip.conf"
)

echo music config

for %%d in (%MPVC_MUSIC%) do (
    mklink "%%d\scripts\cheatsheet.js" "%MPV_CONF%\scripts\cheatsheet_music.js"

    rem git clone --depth=1 https://github.com/Seme4eg/mpv-scripts mpv-scripts@Seme4eg
    mklink "%%d\script-modules\extended-menu.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\script-modules\extended-menu.lua"
    mklink "%%d\scripts\M-x.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\M-x.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\script-opts\M_x.conf" "%MPV_CONF%\script-opts\M_x.conf"
    mklink "%%d\script-opts\M_x.conf" "%MPV_CONF%\script-opts\M_x.conf"
    mklink "%%d\script-modules\leader.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\script-modules\leader.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\leader.lua" "%MPV_CONF%\scripts\leader.lua"
    mklink "%%d\scripts\leader.lua" "%MPV_CONF%\scripts\leader_music.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\script-opts\leader.conf" "%MPV_CONF%\script-opts\leader.conf"
    mklink "%%d\script-opts\leader.conf" "%MPV_CONF%\script-opts\leader.conf"

    rem git clone --depth=1 https://github.com/thinkmcflythink/mpv-loudnorm
    mklink /J "%%d\scripts\real_loudnorm" "%MPV_SRC%\mpv-loudnorm"

    rem git clone --depth=1 https://github.com/cogentredtester/mpv-coverart
    mklink "%%d\scripts\coverart.lua" "%MPV_SRC%\mpv-coverart\coverart.lua"
    :: copy "%MPV_SRC%\mpv-coverart\coverart.conf" "%MPV_CONF%\script-opts\coverart.conf"
    mklink "%%d\script-opts\coverart.conf" "%MPV_CONF%\script-opts\coverart.conf"

    rem git clone --depth=1 https://github.com/cogentredtester/mpv-scripts mpv-scripts@cogentredtester
    mklink "%%d\scripts\save-playlist.lua" "%MPV_SRC%\mpv-scripts@cogentredtester\save-playlist.lua"

    rem git clone --depth=1 https://github.com/stax76/mpv-scripts mpv-scripts@stax76
    mklink "%%d\scripts\smart_volume.lua" "%MPV_SRC%\mpv-scripts@stax76\smart_volume.lua"
)

set "CONFIG_DIR_MANGA=%MPVC_MANGA%"
for %%d in (%CONFIG_DIR_MANGA%) do (
    mklink "%%d\scripts\cheatsheet.js" "%MPV_CONF%\scripts\cheatsheet_manga.js"

    rem git clone --depth=1 https://github.com/Seme4eg/mpv-scripts mpv-scripts@Seme4eg
    mklink "%%d\script-modules\extended-menu.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\script-modules\extended-menu.lua"
    mklink "%%d\scripts\M-x.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\M-x.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\script-opts\M_x.conf" "%MPV_CONF%\script-opts\M_x.conf"
    mklink "%%d\script-opts\M_x.conf" "%MPV_CONF%\script-opts\M_x.conf"
    mklink "%%d\script-modules\leader.lua" "%MPV_SRC%\mpv-scripts@Seme4eg\script-modules\leader.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\leader.lua" "%MPV_CONF%\scripts\leader.lua"
    mklink "%%d\scripts\leader.lua" "%MPV_CONF%\scripts\leader_manga.lua"
    :: copy "%MPV_SRC%\mpv-scripts@Seme4eg\script-opts\leader.conf" "%MPV_CONF%\script-opts\leader.conf"
    mklink "%%d\script-opts\leader.conf" "%MPV_CONF%\script-opts\leader.conf"

    rem git clone --depth=1 https://github.com/occivink/mpv-gallery-view
    mklink "%%d\script-modules\gallery.lua" "%MPV_SRC%\mpv-gallery-view\script-modules\gallery.lua"
    mklink "%%d\scripts\gallery-thumbgen.lua" "%MPV_SRC%\mpv-gallery-view\scripts\gallery-thumbgen.lua"
    mklink "%%d\scripts\playlist-view.lua" "%MPV_SRC%\mpv-gallery-view\scripts\playlist-view.lua"
    :: copy "%MPV_SRC%\mpv-gallery-view\script-opts\playlist_view.conf" "%MPV_CONF%\script-opts\playlist_view.conf"
    mklink "%%d\script-opts\playlist_view.conf" "%MPV_CONF%\script-opts\playlist_view.conf"

    rem git clone --depth=1 https://github.com/guidocella/mpv-image-config
    mklink "%%d\scripts\align-images.lua" "%MPV_SRC%\mpv-image-config\scripts\align-images.lua"
    mklink "%%d\scripts\image-bindings.lua" "%MPV_SRC%\mpv-image-config\scripts\image-bindings.lua"
    rem copy "%MPV_SRC%\mpv-image-config\script-opts\align_images.conf" "%MPV_CONF%\script-opts\align_images.conf"
    rem copy "%MPV_SRC%\mpv-image-config\script-opts\image_bindings.conf" "%MPV_CONF%\script-opts\image_bindings.conf"
    mklink "%%d\script-opts\align_images.conf" "%MPV_CONF%\script-opts\align_images.conf"
    mklink "%%d\script-opts\image_bindings.conf" "%MPV_CONF%\script-opts\image_bindings.conf"
    type "%MPV_SRC%\mpv-image-config\mpv.conf" >> "%%d\mpv.conf"
    type "%MPV_SRC%\mpv-image-config\input.conf" >> "%%d\input.conf"

    rem git clone --depth=1 https://github.com/occivink/mpv-image-viewer
    mklink "%%d\scripts\freeze-window.lua" "%MPV_SRC%\mpv-image-viewer\scripts\freeze-window.lua"
    mklink "%%d\scripts\image-positioning.lua" "%MPV_SRC%\mpv-image-viewer\scripts\image-positioning.lua"
    mklink "%%d\scripts\minimap.lua" "%MPV_SRC%\mpv-image-viewer\scripts\minimap.lua"
    mklink "%%d\scripts\status-line.lua" "%MPV_SRC%\mpv-image-viewer\scripts\status-line.lua"
    mklink "%%d\scripts\detect-image.lua" "%MPV_SRC%\mpv-image-viewer\scripts\detect-image.lua"
    rem copy "%MPV_SRC%\mpv-image-viewer\script-opts\image_positioning.conf" "%MPV_CONF%\script-opts\image_positioning.conf"
    rem copy "%MPV_SRC%\mpv-image-viewer\script-opts\minimap.conf" "%MPV_CONF%\script-opts\minimap.conf"
    rem copy "%MPV_SRC%\mpv-image-viewer\script-opts\status_line.conf" "%MPV_CONF%\script-opts\status_line.conf"
    rem copy "%MPV_SRC%\mpv-image-viewer\script-opts\detect_image.conf" "%MPV_CONF%\script-opts\detect_image.conf"
    mklink "%%d\script-opts\image_positioning.conf" "%MPV_CONF%\script-opts\image_positioning.conf"
    mklink "%%d\script-opts\minimap.conf" "%MPV_CONF%\script-opts\minimap.conf"
    mklink "%%d\script-opts\status_line.conf" "%MPV_CONF%\script-opts\status_line.conf"
    mklink "%%d\script-opts\detect_image.conf" "%MPV_CONF%\script-opts\detect_image.conf"

    rem git clone --depth=1 https://github.com/dudemanguy/mpv-manga-reader
    mklink "%%d\scripts\manga-reader.lua" "%MPV_SRC%\mpv-manga-reader\manga-reader.lua"

    rem git clone --depth=1 https://github.com/jonniek/mpv-nextfile
    mklink "%%d\scripts\nextfile.lua" "%MPV_SRC%\mpv-nextfile\nextfile.lua"
)

rmdir /S /Q %MPV_DATA%
mkdir %MPV_DATA%
fastcopy /open_window /auto_close "%MPVC_VIDEO%" /to="%MPV_DATA%"
echo(

endlocal

pause