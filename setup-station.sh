#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#firefox
check_if_exists firefox || try_install_from_package_manager firefox || \
    { echo 'Installation of firefox failed' ; exit 1; }

#st
check_if_exists st || \
{ \
    cd submodules/st && \
    make && sudo make install && \
    cd ../../; \
} || { echo 'Installation of st failed.' && exit 1; }


#i3
make_folder_if_not_exists $HOME/.config/i3
check_symlink_make_if_not $HOME/.config/i3/config \
    $PWD/conf-files/i3-config || \
    { echo "i3 config link failed" && exit 1 ; }

make_folder_if_not_exists $HOME/.config/i3status
check_symlink_make_if_not $HOME/.config/i3status/config \
    $PWD/conf-files/i3status-config || \
    { echo "i3 statusbar config link failed" && exit 1 ; }

#fzf
check_if_exists "fzf --version" || \
{
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    sudo $HOME/.fzf/install --all ;
} || { echo "fzf install failed" && exit 1 ; }

#LSD && nerd-fonts
{ find "$HOME/.local/share/fonts/NerdFonts" -maxdepth 1 -type d > /dev/null ; } || {
    git clone https://github.com/ryanoasis/nerd-fonts --depth 1 && \
    cd nerd-fonts && \
    ./install.sh && \
    cd .. && \
    rm -rf nerd-fonts
} || { echo 'Installation of nerd-fonts failed' ; exit 1; }

{ find "$HOME/.bash-git-prompt" -maxdepth 1 -type d > /dev/null ; } || {
    git clone https://github.com/magicmonty/bash-git-prompt.git \
        ~/.bash-git-prompt --depth 1
} || { echo 'Installation of git prompt failed' ; exit 1; }

#Must install LSD from sources, snap verison not good
#check_if_exists lsd || sudo snap install lsd --classic || \
#    { echo 'Installation of lsd failed' ; exit 1; }

check_symlink_make_if_not $HOME/.bashrc \
    $PWD/conf-files/bashrc || \
    { echo "bashrc link failed" && exit 1 ; }

install_scripts_from_folder scripts/station
