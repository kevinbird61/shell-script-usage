#!/bin/bash

# setup environment & desktop system
sudo apt-get install build-essential cinnamon

# installation vim & gedit & git & gnome-terminal
sudo apt-get install vim gedit gedit-plugins git gnome-terminal

# get ready for vimrc
echo "set nocompatible
set backspace=2
set number
set hls
set tabstop=4
set autoindent
set cursorline
set encoding=utf8
set background=dark
syntax on
colorscheme evening

\" Color
hi Pmenu ctermbg=white
hi Pmenu ctermfg=black
hi PmenuSel ctermfg=white ctermbg=blue
hi Normal  ctermfg=252 ctermbg=none
 
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
filetype plugin indent on" >> ~/.vimrc

# setting for git
read -p "[Git setting] Enter for the Git user name:" username
git config --global user.name "${username}"
read -p "[Git setting] Enter for the Git user email:" umail
git config --global user.email "${umail}"
read -p "[Git setting] Enter for your Git editor:" gitedit
git config --global core.editor "${gitedit}"

# for language
sudo apt-get install hime

# for brower 
sudo apt-get install chromium-browser

# Download and Installation for dropbox
# First , we need to test the PC environment
usystem=$(uname -a)
match_deb=''
if [[ $usystem == *"i686"* || $usystem == *"i386"* ]]; then
	wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_i386.deb
	match_deb='dropbox_2015.10.28_i386.deb'
elif [[ $usystem == *"x86_64"* ]]; then
	wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb
	match_deb='dropbox_2015.10.28_amd64.deb'

sudo apt-get install python-gtk2 
sudo dpkg -i ${match_deb}
dropbox start
dropbox start -i

# update
sudo apt-get update


