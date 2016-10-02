#!/bin/bash
# Usage : update the tcp server
echo "Using shell script to update the server file between windows computer and Linux server."
echo "If your PC OS is Windows with bash , put the all server file in the /mnt/usr(Create by you), and destination is to 140.116.245.242"

# Ask the file path
read -p "The source file source is from /mnt/usr , do you want to change it?(Y/N): " ans
if [ "${ans}" == "Y" ] || [ "${ans}" == "y" ]; then
	read -p "Want to change , now type your file path :" path
	lftp -c "open -u NCKUSU,nckusu2016 sftp://140.116.245.242/; mirror -c --verbose=9 -e -R -L ${path} /home/NCKUSU/html_storage"
else
	echo "The source path doesn't change!"
	lftp -c "open -u NCKUSU,nckusu2016 sftp://140.116.245.242/; mirror -c --verbose=9 -e -R -L /mnt/usr /home/NCKUSU/html_storage"
	#/usr/local/www/apache24/data/
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
	echo "Login command taken! , With login account NCKUSU:"
	ssh NCKUSU@140.116.245.242
else
	echo ${answer}
	echo "Login command reject!"
fi
