#!/bin/bash
MAIN="LifeGamer-Main"
WEB="LifeGamer-WebService"
TARGET="https://github.com/kevinbird61/LifeGamer.git"
# Make Surec tools install
sudo apt-get install git qt5-default

# Download from github
sudo -rm -rf $MAIN $WEB
git clone $TARGET $MAIN
git clone $TARGET --branch web $WEB

# Create web service 
cd LifeGamer-WebService/Lobby && sudo npm run all&

# Create server
cd $MAIN/LifeGamer_server && qmake && make && ./LifeGamer_server&
