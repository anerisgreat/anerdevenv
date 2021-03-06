#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#pandoc
check_if_exists pandoc || try_install_from_package_manager pandoc || {
    wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-linux.tar.gz && \
    sudo tar -xvzf pandoc-2.7.3-linux.tar.gz --strip-components 1 -C /usr/local/ && \
    rm pandoc-2.7.3-linux.tar.gz || \
    { echo 'Installation of inotify-tools failed' ; exit 1; } \
}

#pdflatex
check_if_exists pdflatex || try_install_from_package_manager texlive-full || {
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

#revealjs
{ find "$HOME/.reveal.js" -maxdepth 1 -type d > /dev/null ; } || {
    wget https://github.com/hakimel/reveal.js/archive/master.zip &&
    unzip master.zip &&
    rm master.zip &&
    mv reveal.js-master $HOME/.reveal.js ;
}

install_scripts_from_folder scripts/office
