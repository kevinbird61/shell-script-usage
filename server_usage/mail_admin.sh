#!/bin/sh

# ====== Variable ====== #
today="$(date +'%Y%m%d')"  
LOC="/home/CSNA2016"
BK_LOC="/home/kevinbird61"
USER_MAIL="kevinbird61@gmail.com"

# execute the fetching log first
sh ${LOC}/main_getloginfo.sh
# execute the remote backup
echo "[Remote Backup Info.] " >> ${LOC}/$today.log
sh ${LOC}/remote_backup.sh >> ${LOC}/$today.log
echo " " >> ${LOC}/$today.log

# And Mail it to me
mail -s "F74026103_"$today"_syslog" ${USER_MAIL} < ${LOC}/$today.log 

# For TA's
mail -s "F74026103_"$today"_syslog" csna@imslab.org < ${LOC}/$today.log

# And then backup CSNA_hw2.sh to /home/kevinbird61
cp ${LOC}/main_getloginfo.sh ${BK_LOC}/CSNA_hw2_backup.sh
cp ${LOC}/mail_admin.sh ${BK_LOC}/hw2Mail_backup.sh
cp ${LOC}/cleanlog.sh ${BK_LOC}/cleanlog_backup.sh
cp ${LOC}/get_weather.sh ${BK_LOC}/get_weather_backup.sh
