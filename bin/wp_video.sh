wp run mpv \
--player-operation-mode=pseudo-gui \
--force-window=yes \
--terminal=no \
--no-audio \
--loop=inf \
--loop-playlist=inf \
--input-ipc-server=\\.\pipe\mpvsocket \
"video.mp4"

wp mv --wait --class mpv -x 1920
wp add --wait --fullscreen --class mpv