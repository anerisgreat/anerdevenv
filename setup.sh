sudo apt-get install -y neovim tmux

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

mkdir $HOME/.config/nvim
ln -sf $PWD/home_files/.config/nvim/init.vim $HOME/.config/nvim/init.vim
ln -sf $PWD/home_files/.config/nvim/init.vim $HOME/.vimrc
ln -sf $PWD/home_files/.tmux.conf $HOME/.tmux.conf

vim +PluginInstall +qall
export TERM=xterm-256color
