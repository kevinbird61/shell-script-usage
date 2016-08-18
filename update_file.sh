#!/bin/bash
# Usage : update the tcp server
echo "Using shell script to update the server file between windows computer and Linux server."
echo "Put the all server file in the /mnt/d/Dropbox/TestServer/ , and destination is to 140.116.245.242/home/imslab/Kevinbird/TestServer"

# Ask the file path
read -p "The source file source is from /mnt/d/Dropbox/TestServer/ , do you want to change it?(Y/N): " ans
if [ "${ans}" == "Y" ] || [ "${ans}" == "y" ]; then
	read -p "Want to change , now type your file path :" path
	rsync -aP ${path} -e ssh imslab@140.116.245.242:/home/imslab/Kevinbird/TestServer/
else
	echo "The source path doesn't change!"
	rsync -aP /mnt/d/Dropbox/TestServer/ -e ssh imslab@140.116.245.242:/home/imslab/Kevinbird/TestServer/
fi

# judge whether rsync is succeed or not 
if [ "$?" -eq 0 ]; then 
	echo "The file upload successfully!!"
else
	echo "The file upload is fail!"
	exit 0
fi

# ask if user want to login the remote server
read -p "Want to login to server 140.116.245.242? : (Y/N)" answer

if [ "${answer}" == "Y" ] || [ "${answer}" == "y" ]; then
	echo "Login command taken!"
	ssh imslab@140.116.245.242
else
	echo ${answer}
	echo "Login command reject!"
fi
