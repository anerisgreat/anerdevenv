#!/bin/bash
tmuxPrevWindow=$(tmux display-message -p '#S.#I')
if [ $1 -eq 1 ]
then
    source ./select_tmux_window.sh
fi
tmux display-panes -d 100000
