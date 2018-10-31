sudo apt-get install -y neovim tmux

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
