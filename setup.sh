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
	usystem='i386'
elif [[ $usystem == *"x86_64"* ]]; then
	wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb
	match_deb='dropbox_2015.10.28_amd64.deb'
	usystem='x86_64'
fi

# Find out the match name with that debian file
for entry in `ls`; do 
	if [[ $entry == *$match_deb* ]]; then
		match_deb = $entry
		break
	fi
done

sudo apt-get install python-gtk2 
sudo dpkg -i ${match_deb}
dropbox start
dropbox start -i

# Installation of Qt
read -p "[Qt Installation request]What kind of Qt you want to install?(Server/User)" mode
if [[ $mode == "Server" ]];then
	# Step 1 : Installing the License File (Ignore first)
	# Step 2 : Unpacking the Archive
	mkdir Qt-Install && cd Qt-Install
	wget http://download.qt.io/official_releases/qt/5.7/5.7.0/single/qt-everywhere-opensource-src-5.7.0.tar.gz
	gunzip qt-everywhere-opensource-src-5.7.0.tar.gz
	tar xvf qt-everywhere-opensource-src-5.7.0.tar
	# Step 3 : Building the Library
	cd qt-everywhere-opensource-src-5.7.0
	sudo apt-get install screen
	screen ./configure && make && make install
	# Step 4 : Set the environment variables
	PATH=/usr/local/Qt-5.7.0/bin:$PATH
	export PATH
elif [[ $mode == "User" ]];then
	if [[ $usystem == "i386" ]];then
		wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x86-online.run
		chmod +x qt-unified-linux-x86-online.run
		./qt-unified-linux-x86-online.run
	else
		wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
		chmod +x qt-unified-linux-x64-online.run
		./qt-unified-linux-x64-online.run
	fi
else
	echo "Wrong input , ignore Qt installation!"
fi

# Install WPS as document manager
if [[ $usystem == "i386" ]]; then
	echo "[WPS installation] Install 32-bits version of WPS"
	wget http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_i386.deb
	sudo dpkg -i wps-office_10.1.0.5672~a21_i386.deb
else 
	echo "[WPS installation] Install 64-bits version of WPS"
	wget http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_amd64.deb
	sudo dpkg -i wps-office_10.1.0.5672~a21_amd64.deb
fi

# update
sudo apt-get update

# Asking user install LAMP or not
read -p "Do you want to install LAMP on this computer?(Y/N)" lamp_ans
if [[ $lamp_ans == "Y" || $lamp_ans == "y" ]]; then
	sudo apt-get install lamp-server^
else
	echo "Ok , Just ignore this step!"
fi
