#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#m4
check_configure_make_install m4 ftp://ftp.gnu.org/gnu/m4/m4-latest.tar.gz m4

#autoconf
check_configure_make_install autoconf \
    ftp://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz \
    autoconf

#automake
check_configure_make_install automake \
    http://ftp.gnu.org/gnu/automake/automake-1.16.tar.gz \
    automake

#libtoolize
check_configure_make_install libtoolize \
    http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz \
    libtoolize

#curl
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

#tmux
check_if_exists tmux || sudo snap install tmux --classic || \
    { echo 'Installation of tmux failed' ; exit 1; }

check_symlink_make_if_not $HOME/.tmux.conf $PWD/conf-files/tmux.conf || \
    { echo "tmux config link failed" && exit 1 ; }

#inotify-tools
check_configure_make_install inotify-tools \
    http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz \
    inotifywait

export TERM=xterm-256color

install_scripts_from_folder scripts/base
