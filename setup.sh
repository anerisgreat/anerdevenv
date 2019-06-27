#!/bin/bash
[ "$USER" = root ] && echo "This script shouldn't be run as root. Aborting." && exit 1

{ ! command -v git ; } && echo "Must install git before proceeding! Aborting." && exit 1
{ ! command -v snap ; } && echo "Must install snap before proceeding! Aborting." && exit 1
{ ! command -v gcc ; } && echo "Must install gcc before proceeding! Aborting." && exit 1
{ ! command -v g++ ; } && echo "Must install g++ before proceeding! Aborting." && exit 1
{ ! command -v make ; } && echo "Must install make before proceeding! Aborting." && exit 1


#TMUX
command -v tmux || sudo snap install tmux --classic

command -v curl || \
git clone https://github.com/curl/curl.git && \
cd curl && \
#env PKG_CONFIG_PATH=/usr/lib/pkgconfig ./configure --with-ssl
make && \
sudo make install && \
cd .. && \
rm -rf curl || { echo 'Installation of CURL failed' ; exit 1; }


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

