#!/bin/bash

# setup environment & desktop system
sudo apt-get install build-essential

# installation 
sudo apt-get install vim git dia shutter


# get ready for vimrc and bashrc
git clone https://github.com/kevinbird61/Linux-Environment.git
rm ~/.vimrc
cp Linux-Environment/vimrc/.vimrc ~
rm ~/.bashrc
cp Linux-Environment/bashrc/.bashrc ~


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
if [[ $usystem == *"i686"* || $usystem == *"i386"* ]]; then
	wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_i386.deb
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
	usystem='i386'
elif [[ $usystem == *"x86_64"* ]]; then
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	usystem='x86_64'
fi

# Enable daemon
~/.dropbox-dist/dropboxd

# Installation of Qt
read -p "[Qt Installation request]What kind of Qt you want to install?(Server/User/No)" mode
if [[ $mode == "Server" || $mode == "server" || $mode == "s" ]];then
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
elif [[ $mode == "User" || $mode == "user" || $mode == "u" ]];then
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

# mesa
sudo apt-get install libgl1-mesa-dev

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
