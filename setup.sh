#!/bin/sh

basicboot="~/.basicboot"
mkdir -p $basicboot

## back up dotfile
backup_date=$(date +"%m-%d-%Y_%T")

backup_dotfiles_and_linknew() {

    mkdir -p ~/dotfbkp_$backup_date

    while [ $# -ne 0 ]; do
        mv ~/$1 ~/dotfbkp_$backup_date
        ln -s `pwd`/$1 ~/dotfile$1
        shift
    done
}

backup_dotfiles_and_linknew .vimrc .zshrc .screenrc .inputrc


## zsh setup
sudo apt-get install zsh
git clone git://github.com/zsh-users/antigen.git "${basicboot}/antigen"
sudo chsh -s /bin/zsh

if [ ! -e ~/.envrc ]; then
    cp dotfile.envrc ~/.envrc;
fi


## vim setup
mkdir -p ~/.vim/tmp
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
vim +PluginInstall +qall
echo 'Setup done.'
