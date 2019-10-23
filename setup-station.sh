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

#firefox
check_if_exists firefox || try_install_from_package_manager firefox || \
    { echo 'Installation of firefox failed' ; exit 1; }

#flameshot
check_if_exists flameshot || try_install_from_package_manager flameshot || \
    { echo 'Installation of flameshot failed' ; exit 1; }

check_if_exists xfce4-terminal || try_install_from_package_manager xfce4-terminal || \
    { echo 'Installation of xfce4-terminal failed' ; exit 1; }

check_symlink_make_if_not $HOME/.config/xfce4/terminal/terminalrc \
    $PWD/conf-files/terminalrc || \
    { echo "xfce4 terminal config link failed" && exit 1 ; }

#i3
make_folder_if_not_exists $HOME/.config/i3
check_symlink_make_if_not $HOME/.config/i3/config \
    $PWD/conf-files/i3-config || \
    { echo "i3 config link failed" && exit 1 ; }

check_symlink_make_if_not $HOME/.config/wallpapers \
    $PWD/wallpapers || \
    { echo "wallpapers link failed" && exit 1 ; }

make_folder_if_not_exists $HOME/.config/i3status
check_symlink_make_if_not $HOME/.config/i3status/config \
    $PWD/conf-files/i3status-config || \
    { echo "i3 statusbar config link failed" && exit 1 ; }

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

#Must install LSD from sources, snap verison not good
#check_if_exists lsd || sudo snap install lsd --classic || \
#    { echo 'Installation of lsd failed' ; exit 1; }

check_symlink_make_if_not $HOME/.bashrc \
    $PWD/conf-files/bashrc || \
    { echo "bashrc link failed" && exit 1 ; }

check_symlink_make_if_not $HOME/.zshrc \
    $PWD/conf-files/zshrc || \
    { echo "zshrc link failed" && exit 1 ; }

install_scripts_from_folder scripts/station
