#!/bin/sh

set -x

scriptdir=$(dirname "$0")

mkdir -p ~/.basicboot

## back up dotfile
backup_date=$(date +"%m-%d-%Y_%T")

backup_dotfiles_and_linknew() {

  mkdir -p ~/dotfbkp_$backup_date

  while [ $# -ne 0 ]; do
    mv ~/$1 ~/dotfbkp_$backup_date
    ln -s `pwd`/dotfile$1 ~/$1
    shift
  done
}

backup_dotfiles_and_linknew .vimrc .zshrc .screenrc .inputrc

if [ -z "$(ls -A ~/dotfbkp_$backup_date)" ]; then
  echo Deleting empty backup directory.
  rm -rf ~/dotfbkp_$backup_date
fi


## zsh setup
if [ ! -d ~/.basicboot/antigen ]; then
  sudo apt-get install zsh
  git clone git://github.com/zsh-users/antigen.git ~/.basicboot/antigen
  sudo chsh -s /bin/zsh

  if [ ! -e ~/.envrc ]; then
    touch ~/.envrc;
  fi
fi


## vim setup
if [ ! -d ~/.vim/bundle/vundle ]; then
  sudo apt-get install vim-gtk
  mkdir -p ~/.vim/tmp
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
  vim +PluginInstall +qall
  echo 'Setup done.'
fi

## fonts
if [ -x "$(command -v fc-cache)" ]; then

  mkdir -p ~/.fonts
  cp ${scriptdir}/ext/*.otf ~/.fonts
  cd ~/.fonts
  fc-cache -vf ~/.fonts
fi
