#!/bin/bash

check_if_exists () {
    { command -v $1 > /dev/null && return 0 ; } || return 1
}

check_if_exists_or_abort () {
    { ! check_if_exists $1 ; } && \
    echo "Must install $1 before proceeding! Aborting." && \
    exit 1 ;# || \
    #echo "$1 found"
}

check_symlink() {
    tmp=$(find "$1" -maxdepth 1 -type l)
    target=$(readlink -f $tmp)
    [ $target == $2 ] && return 0 || return 1
}


check_symlink_make_if_not() {
    check_symlink $1 $2 && return 0
    echo "NO SYMLINK"
    find "$1" -maxdepth 1 -type l && unlink $1 && ln -s $2 $1 && return 0
    echo "NO WHATEVER"
    find "$1" -maxdepth 1 -type f && rm $1 && ln -s $2 $1 && return 0
    echo "NO HOOYAH"
    find "$1" -maxdepth 1 -type d && rm -r $1 && ln -s $2 $1 && return 0
    echo "FEKKER FEKKER"
    ln -s $2 $1 && return 0
    return 1
}

sudo_check_symlink_make_if_not() {
    check_symlink $1 $2 && return 0
    find "$1" -maxdepth 1 -type l > /dev/null && sudo unlink $1 && \
        sudo ln -s $3 $1 && return 0
    find "$1" -maxdepth 1 -type f > /dev/null && sudo rm $1 && \
        sudo ln -s $2 $1 && return 0
    find "$1" -maxdepth 1 -type d > /dev/null && sudo rm -r $1 && \
        sudo ln -s $2 $1 && return 0
    sudo ln -s $2 $1 && return 0
    return 1
}

make_folder_if_not_exists() {
    { find "$1" -maxdepth 1 -type d > /dev/null || mkdir $1 -p ; } && return 0
    echo "Could not find directory $1 and encountered error creating it!"
    exit 1
}

[ "$USER" = root ] && echo "This script shouldn't be run as root. Aborting." \
    && exit 1

check_if_exists_or_abort git
check_if_exists_or_abort gcc
check_if_exists_or_abort g++
check_if_exists_or_abort make
check_if_exists_or_abort snap

#m4
check_if_exists m4 || {
    wget ftp://ftp.gnu.org/gnu/m4/m4-latest.tar.gz && \
    tar -xzf m4-latest.tar.gz && \
    tmp=$(tar -tzf m4-latest.tar.gz | head -1 | cut -f1 -d"/") && \
    cd $tmp && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf $tmp m4-latest.tar.gz
} || { echo 'Installation of m4 failed' ; exit 1 ; }

#autoconf
check_if_exists autoconf || {
    wget ftp://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz && \
    tar -xzf autoconf-latest.tar.gz && \
    tmp=$(tar -tzf autoconf-latest.tar.gz | head -1 | cut -f1 -d"/") && \
    cd $tmp && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf $tmp autoconf-latest.tar.gz
} || { echo 'Installation of autoconf failed' ; exit 1 ; }

#automake
check_if_exists automake || {
    wget http://ftp.gnu.org/gnu/automake/automake-1.16.tar.gz && \
    tar -xzf automake-1.16.tar.gz && \
    tmp=$(tar -tzf automake-1.16.tar.gz | head -1 | cut -f1 -d"/") && \
    cd $tmp && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf $tmp automake-1.16.tar.gz
} || { echo 'Installation of automake failed' ; exit 1 ; }

#libtool
check_if_exists libtoolize || {
    wget http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz && \
    tar -xzf libtool-2.4.6.tar.gz && \
    tmp=$(tar -tzf libtool-2.4.6.tar.gz | head -1 | cut -f1 -d"/") && \
    cd $tmp && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf $tmp libtool-2.4.6.tar.gz
} || { echo 'Installation of libtoolize failed' ; exit 1 ; }

check_if_exists curl || { \
    git clone https://github.com/curl/curl.git && \
    cd curl && \
    #env PKG_CONFIG_PATH=/usr/lib/pkgconfig ./configure --with-ssl
    ./buildconf && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf curl || { echo 'Installation of CURL failed' ; exit 1; } }

#TMUX
check_if_exists tmux || sudo snap install tmux --classic

#CMAKE
check_if_exists cmake || sudo snap install cmake --classic

#NEOVIM
{   check_if_exists nvim || \
    { wget https://github.com/neovim/neovim/releases/download/v0.3.7/nvim.appimage && \
        chmod u+x nvim.appimage && sudo mv ./nvim.appimage /usr/bin/nvim  ; } \
|| { echo 'Installation of NVIM failed' ; exit 1; } } && { \
    #Post NVIM installation
    {
        nvim_location=$(command -v nvim) && \
        sudo_check_symlink_make_if_not '/usr/bin/vim' $nvim_location
    } || echo "nvim to vim symbolink linkage failed" ;
}

#sudo apt-get install -y inotify-tools


find "$HOME/.vim/bundle/Vundle.vim" -maxdepth 1 -type d || git clone \
    https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

#Mapping configurations
make_folder_if_not_exists $HOME/.config/nvim
check_symlink_make_if_not $HOME/.config/nvim/init.vim \
    $PWD/conf_files/vim-config || \
    { echo "nvim config link failed" && exit 1 ; }
check_symlink_make_if_not $HOME/.vimrc $PWD/conf_files/vim-config || \
    { echo "nvim config link failed" && exit 1 ; }

check_symlink_make_if_not $HOME/.tmux.conf $PWD/conf_files/tmux-config || \
    { echo "tmux config link failed" && exit 1 ; }

make_folder_if_not_exists $HOME/.config/i3
check_symlink_make_if_not $HOME/.config/i3/config \
    $PWD/conf_files/i3-config || \
    { echo "i3 config link failed" && exit 1 ; }

make_folder_if_not_exists $HOME/.config/i3status
check_symlink_make_if_not $HOME/.config/i3status/config \
    $PWD/conf_files/i3status-config || \
    { echo "i3 statusbar config link failed" && exit 1 ; }

vim +PluginInstall +qall
export TERM=xterm-256color

#Custom script installation

ls -la /usr/local/bin/ | grep "anerdevenv/scripts" |\
    awk -F '->' '{print $1}' |\
    awk -F ' ' '{print $NF}' |\
    while read line ; do sudo rm /usr/local/bin/$line ; done

chmod -R a+x scripts
sudo ln -s $PWD/scripts/* /usr/local/bin/ || \
    { echo "Script linkage failed" && exit 1 ; }

#fzf
check_if_exists "fzf --version" || \
{
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    sudo $HOME/.fzf/install --all ;
} || { echo "fzf install failed" && exit 1 ; }

#Installation of reveal js for pandoc
#UNTIL THEY FIX IT
#wget https://github.com/hakimel/reveal.js/archive/master.tar.gz
#tar -xzvf master.tar.gz
#rm master.tar.gz
#sudo mv master /usr/local/lib/.reveal.js
wget https://github.com/hakimel/reveal.js/archive/3.7.0.tar.gz
tar -xzvf 3.7.0.tar.gz
rm 3.7.0.tar.gz
sudo rm -r /usr/local/lib/.reveal.js
sudo mv reveal.js-3.7.0 /usr/local/lib/.reveal.js

sudo ldconfig

