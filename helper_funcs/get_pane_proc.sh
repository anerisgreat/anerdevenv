#!/bin/bash
tmuxPrevWindow=$(tmux display-message -p '#S.#I')
if [ $1 -eq 1 ]
then
    read -rsn1 nextWindow
    echo $nextWindow
    tmux display-message "$nextWindow"
fi
tmuxActiveWindow=$(tmux display-message -p '#S.#I')
tmuxWindowPIDs=$(tmux list-panes -F '#{pane_pid}')
pane=$2
paneInc=$((pane+1))
relevantPID=$(echo $tmuxWindowPIDs | tr -s ' ' | cut -d ' ' -f $paneInc)
procList=$(ps -o comm= -g$relevantPID | tr -s ' ')
procName=$(echo $procList | rev | cut -d ' ' -f1 | rev)
echo $procName
