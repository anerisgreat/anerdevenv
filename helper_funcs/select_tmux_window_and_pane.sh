#!/usr/bin/env bash
cd "$(dirname "$0")"
ret=n
tmuxPrevWindow=$(tmux display-message -p '#I')
tmuxPrevPane=$(source ./get_active_pane_id.sh)

if [ "$1" -eq "1" ]
then
    windowChoice=$(source select_tmux_window.sh)
    if [ "$windowChoice" != "n" ]
    then
        tmux select-window -t $windowChoice
    fi
else
    windowChoice=$tmuxPrevWindow
fi

if [ "$windowChoice" != "n" ]
then
    tmux -c "tmux display-panes -d 3600000 "
    choice=X
    while [ "$choice" != "y" ] && [ "$choice" != "n" ] && [ "$choice" != "x" ]
    do
        tmux command-prompt -1 -p "Confirm y/n "\
            "choice=%% wait-for -S open_on_pane_choice_made"
        tmux wait-for open_on_pane_choice_made
        choice=$(tmux show-environment -g choice 2>&1 | cut -d '=' -f 2)
    done
    source ./clear_tmux_display.sh

    if [ "$choice" = "y" ]
        then
        tmuxNewWindow=$(tmux display-message -p '#I')
        tmuxNewPane=$(tmux list-panes -F "#Px#{pane_active}p" \
            | grep -w ".x1p" | cut -c1-1)

        if [ "$tmuxPrevWindow" -eq "$tmuxNewWindow" ] \
            && [ "$tmuxPrevPane" -eq "$tmuxNewPane" ]
        then
            tmux display-message "Cannot open on current pane!"
        else
            ret=y
        fi
    fi
fi

echo $ret
