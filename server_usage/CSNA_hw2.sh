#!/bin/sh 
# Author : Kevin Cyu
# Usage  : CSNA class usage.
auth=auth_usage
res=result_usage

# ========= change user to root ==#

# Get the log file from /var/log
# ========= Get auth.log =========#
# Build the workspace
rm -R ${auth}/ ${res}/
mkdir ${auth} ${res}
# Copy the log to dir we make
sudo cp /var/log/auth* ${auth}/
# Pop out all message in auth_usage/ , and then fetch the userlog
bzip2 -d ${auth}/*.bz2
# cat all comment to a file
cat ${auth}/* >> ${res}/total.log
# cut the useful information
cat ${res}/total.log | grep -v ^total | \
		awk '\
		$6=="Invalid" \
		{print $1 " " $2 " " $6 \
			   " USER:" $8 \
			   " HOST:" $10 } \
		' > ${res}/Invalid_user.log
# Calculate for Line
cat ${res}/Invalid_user.log | awk '{split($4,a,":")} {print a[2]}' | sort | uniq | wc -l | awk '{printf "user_count: %s, " ,$1}' >> ${res}/Invalid_user.log && cat ${res}/Invalid_user.log | awk '{split($5,b,":")} {print b[2]} ' | sort | uniq | wc -l | awk '{printf "host_count: %s\n", $1}' >> ${res}/Invalid_user.log 

cat ${res}/total.log | grep -v ^total | \
		awk '\
		$6=="Accepted" \
		{print $1 " " $2 " " $6 \
			   " USER:" $9 \
			   " HOST:" $11 \
			   } \
		' > ${res}/Accepted_user.log
# Calculate for Line
cat ${res}/Accepted_user.log | awk '{split($4,a,":")} {print a[2]}' | sort | uniq | wc -l | awk '{printf "user_count: %s, ",$1}' >> ${res}/Accepted_user.log && cat ${res}/Accepted_user.log | awk '{split($5,b,":")} {print b[2]}' | sort | uniq | wc -l | awk '{printf "host_count: %s\n",$1}' >> ${res}/Accepted_user.log

cat ${res}/total.log | grep -v ^total | \
		awk '\
		$6=="error:" \
		{
			filter=1
			user=""
			host=""
			for(i=1;i<=NF;i=i+1){
				if($i=="from")
					filter=2
				if(filter==0) 
					user=user $i " "
				if(filter==2){
					host= $(i+1)
					break
				}
				if($i=="for") 
					filter=0
			}
			print $1 " " $2 " " $6 \
				" USER:" user \
				" HOST:" host \
		} \
		' > ${res}/Error_user.log
# Calculate for Line
cat ${res}/Error_user.log | awk '{split($4,a,":")} {print a[2]}' | sort | uniq | wc -l | awk '{printf "user_count: %s, ",$    1}' >> ${res}/Error_user.log && cat ${res}/Error_user.log | awk '{split($5,b,":")} {print b[2]}' | sort | uniq | wc -l     | awk '{printf "host_count: %s\n",$1}' >> ${res}/Error_user.log
			
# ========== Here we have complete auth.log =========== #
# Hard disk usage
df > ${res}/hard_disk.log

# difference of setuid program
diff /var/log/setuid.yesterday /var/log/setuid.today -b > ${res}/Diff_setuid_program.log

# ========== Now we have to backup the file =========== #
backup="$(date | awk '{print "backup_" $2 "_" $3 "_bk"}')"
# remove backup first
if [ -d "/root/backup/" ]; then
	rm -R /root/backup/
fi
# make new backup directory
mkdir /root/backup
# start copy backup
mkdir /root/backup/home_bk
cp -R /home/ /root/backup/home_bk/
mkdir /root/backup/mail_bk
cp -R /var/mail/ /root/backup/mail_bk/
mkdir /root/backup/etc_bk
cp -R /etc/ /root/backup/etc_bk/
mkdir /root/backup/ul_etc_bk
cp -R /usr/local/etc/ /root/backup/ul_etc_bk/
# And then packup , send back to here
if [ ! -d "/root/backup_tar/" ]; then
	mkdir /root/backup_tar
fi
tar -zcf /root/backup_tar/$backup.tar.gz /root/backup
rm -r /root/backup

# After backup all these files , we need to check the back_tar folder , maintain 3 days backup
# Get the total number in backup_tar

total_number="$(ls /root/backup_tar/ | awk '{split($1,a,"_")} {print a[3]}' | wc -l)"
if [ $total_number -gt 3 ]; then
	# Create backup_final as temp storage
	if [ -d "/root/backup_final/" ]; then
		rm -r /root/backup_final
		mkdir /root/backup_final
	else
		mkdir /root/backup_final
	fi
	# Move 3 lastest into final dir
	for i in 3 2 1
	do 
		current_max="$(ls /root/backup_tar/ | awk '{split($1,a,"_")} {print a[3]}' | sort -g | tail -n 1)"
		match_str="$(ls /root/backup_tar/ | awk -v max="$current_max" '{split($1,a,"_")} \
					a[3]==max {print $1}')"
		mv /root/backup_tar/${match_str} /root/backup_final/	
	done
	# Delete all the other file whether are not in backup_final
	rm /root/backup_tar/*
	# move back all tar from final
	mv /root/backup_final/* /root/backup_tar/
	# And then we remove final dir
	rm -r /root/backup_final
fi

# Now we have backup and log file , so we need to summarize the log files , and remove all working directory gently
# Starting writing into today's log 
todaylog="$(date +'%Y%m%d' | awk '{print $1 ".log"}')"
rm /home/CSNA2016/$todaylog
# get today's weather
echo "Hello there, this is kevin cyu's automatic mail , read it and be happy today!" >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[Today Weather News]" >> /home/CSNA2016/$todaylog
sh /home/CSNA2016/get_weather.sh >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[Accepted User]" >> /home/CSNA2016/$todaylog
cat ${res}/Accepted_user.log >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[Invalid User]" >> /home/CSNA2016/$todaylog
cat ${res}/Invalid_user.log >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[Error Logins]" >> /home/CSNA2016/$todaylog
cat ${res}/Error_user.log >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[Hard Disk Usage]" >> /home/CSNA2016/$todaylog
cat ${res}/hard_disk.log >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[Difference of setuid programs]" >> /home/CSNA2016/$todaylog
cat ${res}/Diff_setuid_program.log  >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog
echo "[My Crontab Content]" >> /home/CSNA2016/$todaylog
cat /etc/crontab >> /home/CSNA2016/$todaylog
echo " " >> /home/CSNA2016/$todaylog

# And wrapout all file in ${res} and ${auth}
rm -r ${res} ${auth}
