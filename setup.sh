#!/bin/bash

source $PWD/helper_funcs/setup_core.sh

[ "$USER" = root ] && echo "This script shouldn't be run as root. Aborting." \
    && exit 1

check_if_exists_or_abort git
check_if_exists_or_abort gcc
check_if_exists_or_abort g++
check_if_exists_or_abort make
check_if_exists_or_abort snap

check_configure_make_install m4 ftp://ftp.gnu.org/gnu/m4/m4-latest.tar.gz m4

check_configure_make_install autoconf \
    ftp://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz \
    autoconf

check_configure_make_install automake \
    http://ftp.gnu.org/gnu/automake/automake-1.16.tar.gz \
    automake

check_configure_make_install libtoolize \
    http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz \
    libtoolize

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
check_if_exists tmux || sudo snap install tmux --classic || \
    { echo 'Installation of TMUX failed' ; exit 1; }

#CMAKE
check_if_exists cmake || sudo snap install cmake --classic || \
    { echo 'Installation of cmake failed' ; exit 1; }

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

check_configure_make_install inotify-tools \
    http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz \
    inotifywait

#FIREFOX
check_if_exists firefox || sudo snap install firefox --classic || \
    { echo 'Installation of firefox failed' ; exit 1; }

{ find "$HOME/.vim/bundle/Vundle.vim" -maxdepth 1 -type d > /dev/null ; } || {
    git clone \
    https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim ;
} || { echo 'Installation of vundle failed' ; exit 1; }

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

vim +PluginInstall +qall 2> /dev/null
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

#LSD && nerd-fonts
{ find "$HOME/.local/share/fonts/NerdFonts" -maxdepth 1 -type d > /dev/null ; } || {
    git clone https://github.com/ryanoasis/nerd-fonts --depth 1 && \
    cd nerd-fonts && \
    ./install.sh && \
    cd .. && \
    rm -rf nerd-fonts
} || { echo 'Installation of nerd-fonts failed' ; exit 1; }

check_if_exists lsd || sudo snap install lsd || \
    { echo 'Installation of lsd failed' ; exit 1; }

check_if_exists zsh || {
    git clone git://git.code.sf.net/p/zsh/code zsh && \
    cd zsh && \
    Util/preconfig && \
    ./configure && \
    make && \
    sudo make install && \
    cd .. && \
    rm -rf zsh ;
} || { echo 'Installation of ZSH failed' ; exit 1; }

check_if_exists NONEXISTENT || {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
} || { echo 'Installation of Oh My ZSH failed' ; exit 1; }

check_if_exists pandoc || {
    wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-linux.tar.gz && \
    sudo tar -xvzf pandoc-2.7.3-linux.tar.gz --strip-components 1 -C /usr/local/ && \
    rm pandoc-2.7.3-linux.tar.gz || { echo 'Installation of inotify-tools failed' ; exit 1; } \
}

check_if_exists pdflatex || {
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -xzf install-tl-unx.tar.gz && \
    tmp=$(tar -tzf install-tl-unx.tar.gz | head -1 | cut -f1 -d"/") && \
    cd $tmp && \
    echo -e "selected_scheme scheme-full\n"\
"TEXDIR ~/.texlive2019/2019\n"\
"TEXMFCONFIG ~/.texlive2019/texmf-config\n"\
"TEXMFHOME ~/.textlive2019/texmf\n"\
"TEXMFLOCAL ~/.texlive2019/texmf-local\n"\
"TEXMFSYSCONFIG ~/.texlive2019/2019/texmf-config\n"\
"TEXMFSYSVAR ~/.texlive2019/2019/texmf-var\n"\
"TEXMFVAR ~/.texlive2019/texmf-var\n" > tlprofile
    ./install-tl --profile=tlprofile
    cd .. && \
    rm -rf $tmp install-tl-unx.tar.gz || \
    { echo 'Installation of texlive failed.' ; exit 1; }
}

{ find "/usr/local/lib/.reveal.js" -maxdepth 1 -type d > /dev/null ; } || {
    wget https://github.com/hakimel/reveal.js/archive/3.7.0.tar.gz &&
    tar -xzvf 3.7.0.tar.gz &&
    rm 3.7.0.tar.gz &&
    sudo mv reveal.js-3.7.0 /usr/local/lib/.reveal.js ;
}

sudo ldconfig


