#!/bin/bash
tmuxActiveWindow=$(tmux display-message -p '#S.#I')
tmuxWindowPIDs=$(tmux list-panes -F '#{pane_pid}')
pane=$1
paneInc=$((pane+1))
relevantPID=$(echo $tmuxWindowPIDs | tr -s ' ' | cut -d ' ' -f $paneInc)
procList=$(ps -o comm= -g$relevantPID | tr -s ' ')
procName=$(echo $procList | rev | cut -d ' ' -f1 | rev)
echo $procName
