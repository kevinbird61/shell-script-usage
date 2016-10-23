#!/bin/sh

# ====== Variable ====== #
today="$(date +'%Y%m%d')"  

# execute the fetching log first
sh /home/CSNA2016/CSNA_hw2.sh
# execute the remote backup
echo "[Remote Backup Info.] " >> /home/CSNA2016/$today.log
sh /home/CSNA2016/remote_backup.sh >> /home/CSNA2016/$today.log
echo " " >> /home/CSNA2016/$today.log

# And Mail it to me
mail -s "F74026103_"$today"_syslog" kevinbird61@gmail.com < /home/CSNA2016/$today.log 

# For TA's
#mail -s "F74026103_"$today"_syslog" csna@imslab.org < /home/CSNA2016/$today.log

# And then backup CSNA_hw2.sh to /home/kevinbird61
cp /home/CSNA2016/CSNA_hw2.sh /home/kevinbird61/CSNA_hw2_backup.sh
cp /home/CSNA2016/hw2Mail.sh /home/kevinbird61/hw2Mail_backup.sh
cp /home/CSNA2016/cleanlog.sh /home/kevinbird61/cleanlog_backup.sh
cp /home/CSNA2016/get_weather.sh /home/kevinbird61/get_weather_backup.sh
