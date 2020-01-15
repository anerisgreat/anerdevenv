#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#fzf
check_if_exists "fzf --version" || \
{
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    sudo $HOME/.fzf/install --all ;
} || { echo "fzf install failed" && exit 1 ; }

#zsh
check_if_exists zsh || { try_install_from_package_manager zsh ; } || \
    { echo 'Installation of zsh failed' &&  exit 1; }

#emacs
check_if_exists emacs || { try_install_from_package_manager emacs ; } || \
    { echo 'Installation of emacs failed' &&  exit 1; }

{ find "$HOME/.chemacs" -maxdepth 1 -type d > /dev/null ; } || \
{ git clone https://github.com/plexus/chemacs.git ~/.chemacs && \
    cd ~/.chemacs && ./install.sh ; } || \
{ echo 'Installation of DOOM emacs failed' && exit 1 ; }

{ find "$HOME/.prelude" -maxdepth 1 -type d > /dev/null ; } || \
git clone git://github.com/bbatsov/prelude.git ~/.prelude || \
{ echo 'Installation of PRELUDE emacs failed' && exit 1 ; }

{ find "$HOME/.emacs.doom.d" -maxdepth 1 -type d > /dev/null ; } || \
{ git clone https://github.com/hlissner/doom-emacs ~/.emacs.doom.d && \
    ~/.emacs.doom.d/bin/doom install ; } || \
{ echo 'Installation of DOOM emacs failed' && exit 1 ; }

check_symlink_make_if_not $HOME/.config/doom $PWD/conf-files/doom.d || \
{ echo "Symlink .doom.d failed" && exit 1 ; }

check_symlink_make_if_not $HOME/.config/.emacs-profiles.el $PWD/conf-files/emacs-profiles.el || \
{ echo "Symlink emacs profiles failed" && exit 1 ; }

gpg --homedir ~/.emacs.d/elpa/gnupg --receive-keys 066DAFCB81E42C40

{ grep $(whoami) /etc/passwd  | grep zsh > /dev/null ; } || {
echo "Changing shell to zsh" &&
chsh -s $(which zsh | head -1) ; }

#Oh My Zsh
find "$HOME/.oh-my-zsh" -maxdepth 1 -type d > /dev/null ||\
{ sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" && \
rm install.sh ; } ||\
{ echo 'Installation of oh-my-zsh failed' ; exit 1 ; }

find "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" -maxdepth 1 -type d > /dev/null ||\
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ||
{ echo 'Installation of zsh-syntax-highlighting failed.' && exit 1 ; }

#LSD && nerd-fonts
{ find "$HOME/.local/share/fonts/NerdFonts" -maxdepth 1 -type d > /dev/null ; } || {
    git clone https://github.com/ryanoasis/nerd-fonts --depth 1 && \
    cd nerd-fonts && \
    ./install.sh && \
    cd .. && \
    rm -rf nerd-fonts
} || { echo 'Installation of nerd-fonts failed' ; exit 1; }

{ find "$HOME/.bash-git-prompt" -maxdepth 1 -type d > /dev/null ; } || {
    git clone https://github.com/magicmonty/bash-git-prompt.git \
        ~/.bash-git-prompt --depth 1
} || { echo 'Installation of git prompt failed' ; exit 1; }

check_symlink_make_if_not $HOME/.bashrc \
    $PWD/conf-files/bashrc || \
    { echo "bashrc link failed" && exit 1 ; }

check_symlink_make_if_not $HOME/.zshrc \
    $PWD/conf-files/zshrc || \
    { echo "zshrc link failed" && exit 1 ; }

install_scripts_from_folder scripts/terminal
