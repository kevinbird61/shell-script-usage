#!/bin/sh

# Get password
CSNA_pwd="$(cat /root/backup_CSNA/password)"

# FIXME: How to get passthrough the first login (ssh key) part?
sshpass -p ${CSNA_pwd} rsync -aP /root/backup_tar/ backup_CSNA@140.116.219.160:/home/backup_CSNA/CSNA_backup/
