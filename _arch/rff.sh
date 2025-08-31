#!/bin/bash

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_OPTS='--color=dark --height=100% --layout=reverse --inline-info --preview "bat -n --theme=base16-256 --color=always {}" --walker-skip .github --bind="ctrl-e:execute(nvim {} > /dev/tty)+abort"'

fzf "$@"
