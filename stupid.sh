check_symlink() {
    tmp=$(find "$1" -maxdepth 1 -type l)
    target=$(readlink -f $tmp)
    [ $target == $2 ] && return 0 || return 1
    return 1
}

{ check_symlink $HOME/.config/nvim/init.vim $PWD/conf_files/vim-config ; } && echo GOOD

