#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#firefox
check_if_exists firefox || try_install_from_package_manager firefox || \
    { echo 'Installation of firefox failed' ; exit 1; }

#flameshot
check_if_exists flameshot || try_install_from_package_manager flameshot || \
    { echo 'Installation of flameshot failed' ; exit 1; }

check_if_exists xfce4-terminal || try_install_from_package_manager xfce4-terminal || \
    { echo 'Installation of xfce4-terminal failed' ; exit 1; }

check_symlink_make_if_not $HOME/.config/xfce4/terminal/terminalrc \
    $PWD/conf-files/terminalrc || \
    { echo "xfce4 terminal config link failed" && exit 1 ; }

#i3
make_folder_if_not_exists $HOME/.config/i3
check_symlink_make_if_not $HOME/.config/i3/config \
    $PWD/conf-files/i3-config || \
    { echo "i3 config link failed" && exit 1 ; }

check_symlink_make_if_not $HOME/.config/wallpapers \
    $PWD/wallpapers || \
    { echo "wallpapers link failed" && exit 1 ; }

make_folder_if_not_exists $HOME/.config/i3status
check_symlink_make_if_not $HOME/.config/i3status/config \
    $PWD/conf-files/i3status-config || \
    { echo "i3 statusbar config link failed" && exit 1 ; }

install_scripts_from_folder scripts/station
