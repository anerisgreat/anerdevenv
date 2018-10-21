git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -sf $PWD/home_files/.vimrc $HOME/.vimrc
ln -sf $PWD/home_files/.tmux.conf $HOME/.tmux.conf

vim +PluginInstall +qall
export TERM=xterm-256color
