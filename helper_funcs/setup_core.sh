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

check_configure_make_install() {
    check_if_exists $3 || {
        wget -O tmp.tar.gz $2 && \
        tar -xzf tmp.tar.gz && \
        tmp=$(tar -tzf tmp.tar.gz | head -1 | cut -f1 -d"/") && \
        cd $tmp && \
        ./configure && \
        make && \
        sudo make install && \
        cd .. && \
        rm -rf $tmp tmp.tar.gz && \
        return 0 ;
    } || { echo 'Installation of $1 failed' ; exit 1 ; }
}

