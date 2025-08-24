# https://github.com/jimeh/tmuxifier/blob/main/examples/example.session.sh

session_root "~"

if initialize_session "sess"; then
	new_window "Home"
	load_window "config"
	load_window "usr"
	load_window "proj"
	load_window "downloads"
	select_window 0
fi

finalize_and_go_to_session
