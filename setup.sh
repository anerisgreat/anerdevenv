#!/bin/bash

check_if_exists () {
    { command -v $1 > /dev/null && return 0 ; } || return 1
}

check_if_exists_or_abort () {
    { ! check_if_exists $1 ; } && \
    echo "Must install $1 before proceeding! Aborting." && \
    exit 1 || \
    echo "$1 found"
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

#automake
check_if_exists autoconf || {
    wget http://ftp.gnu.org/gnu/automake/automake-1.16.tar.xz && \
    tar -xzf automake-1.16.tar.gz && \
    tmp=$(tar -tzf automake-1.16.tar.gz | head -1 | cut -f1 -d"/") && \
    cd $tmp && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf $tmp automake-1.16.tar.gz
} || { echo 'Installation of autoconf failed' ; exit 1 ; }

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

#TMUX
check_if_exists tmux || sudo snap install tmux --classic
check_if_exists cmake || sudo snap install cmake --classic

command -v curl || { \
    git clone https://github.com/curl/curl.git && \
    cd curl && \
    #env PKG_CONFIG_PATH=/usr/lib/pkgconfig ./configure --with-ssl
    make && \
    sudo make install && \
    cd .. && \
    rm -rf curl || { echo 'Installation of CURL failed' ; exit 1; } }


#sudo apt-get install -y neovim tmux
#sudo apt-get install -y inotify-tools


git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

mkdir $HOME/.config/nvim
ln -sf $PWD/conf_files/vim-config $HOME/.config/nvim/init.vim
ln -sf $PWD/conf_files/vim-config $HOME/.vimrc

ln -sf $PWD/conf_files/tmux-config $HOME/.tmux.conf

mkdir $HOME/.config/i3
rm $HOME/.config/i3/config
ln -sf $PWD/conf_files/i3-config $HOME/.config/i3/config

mkdir $HOME/.config/i3status
ln -s $PWD/conf_files/i3status-config $HOME/.config/i3status/config

vim +PluginInstall +qall
export TERM=xterm-256color

#Custom script installation
ls -la /usr/local/bin/ | grep "anerdevenv/scripts" |\
    awk -F '->' '{print $1}' |\
    awk -F ' ' '{print $NF}' |\
    while read line ; do sudo rm /usr/local/bin/$line ; done

chmod -R a+x scripts
sudo ln -s $PWD/scripts/* /usr/local/bin/

#fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
~/.fzf/install --all

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

