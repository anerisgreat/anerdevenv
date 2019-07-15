#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#CMake
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

make_folder_if_not_exists $HOME/.config/nvim
check_symlink_make_if_not $HOME/.config/nvim/init.vim \
    $PWD/conf-files/vimrc || \
    { echo "nvim config link failed" && exit 1 ; }
check_symlink_make_if_not $HOME/.vimrc $PWD/conf-files/vimrc || \
    { echo "nvim config link failed" && exit 1 ; }

{ find "$HOME/.vim/bundle/Vundle.vim" -maxdepth 1 -type d > /dev/null ; } || {
    git clone \
    https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim ;
} || { echo 'Installation of vundle failed' ; exit 1; }

vim +PluginInstall +qall 2> /dev/null

install_scripts_from_folder scripts/dev
