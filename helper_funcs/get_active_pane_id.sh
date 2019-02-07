echo $(tmux list-panes -F "#Px#{pane_active}p" | grep -w ".x1p" | cut -c1-1)
