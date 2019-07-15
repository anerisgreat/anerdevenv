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
    tmp=$(find "$1" -maxdepth 1 -type l 2>&1 )
    target=$(readlink -f "$tmp")
    [ "$target" == "$2" ] && return 0 || return 1
}

check_symlink_make_if_not() {
    check_symlink $1 $2 && return 0
    { find "$1" -maxdepth 1 -type l > /dev/null 2>&1 ; }&& \
        unlink $1 && ln -s $2 $1 && return 0
    { find "$1" -maxdepth 1 -type f > /dev/null 2>&1 ; }&& \
        rm $1 && ln -s $2 $1 && return 0
    { find "$1" -maxdepth 1 -type d > /dev/null 2>&1 ; }&& \
        rm -r $1 && ln -s $2 $1 && return 0
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

#Custom script installation
install_scripts_from_folder() {
    ls -la /usr/local/bin/ | grep "anerdevenv/$1" |\
        awk -F '->' '{print $1}' |\
        awk -F ' ' '{print $NF}' |\
        while read line ; do {
            echo $line
            sudo rm -rf /usr/local/bin/$line && \
            sudo unlink /usr/local/bin/$line ;
        } ; done

    chmod -R a+x scripts
    sudo ln -s $PWD/$1/* /usr/local/bin/ || \
        { echo "Script linkage failed" && exit 1 ; }
}

#Check applies to all scripts that import
[ "$USER" = root ] && echo "This script shouldn't be run as root. Aborting." \
    && exit 1

check_if_exists_or_abort git
check_if_exists_or_abort gcc
check_if_exists_or_abort g++
check_if_exists_or_abort make
check_if_exists_or_abort snap
