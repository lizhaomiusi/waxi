#!/bin/bash
day=`date +%w`
dt=`date +%Y%m%d`
lastday=`date -d '1 days ago' +%Y%m%d`
user=root
pwd='xxxxx'
log=backuplog.`date +%Y%m%d`

case $day in  
    0)  
        # Sunday Full backup
        find /backup/ -name "xtra_*" -mtime +6 -exec rm -rf {} \;
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd --no-timestamp /backup/xtra_base_$dt > /tmp/$log 2>&1
        ;;  
    1)  
        # Monday Relatively Sunday's incremental backup  
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd  --no-timestamp  --incremental  /backup/xtra_inc_$dt --incremental-basedir=/backup/xtra_base_$lastday > /tmp/$log 2>&1  
        ;;  
    2)  
        # Tuesday Compared with Monday's incremental backup  
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd  --no-timestamp  --incremental  /backup/xtra_inc_$dt --incremental-basedir=/backup/xtra_inc_$lastday > /tmp/$log 2>&1     
        ;;  
    3)  
        # Wednesday Full backup
        find /backup/ -name "xtra_*" -mtime +6 -exec rm -rf {} \;
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd --no-timestamp /backup/xtra_base_$dt > /tmp/$log 2>&1   
        ;;  
    4)  
        # Thursday  Relatively Wednesday's incremental backup  
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd  --no-timestamp  --incremental  /backup/xtra_inc_$dt --incremental-basedir=/backup/xtra_base_$lastday > /tmp/$log 2>&1    
        ;;  
    5)  
        # Friday Compared with Thursday's incremental backup  
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd  --no-timestamp  --incremental  /backup/xtra_inc_$dt --incremental-basedir=/backup/xtra_inc_$lastday > /tmp/$log 2>&1    
        ;;  
    6)  
        # Saturday Compared with Friday's incremental backup  
        innobackupex --defaults-file=/etc/my.cnf  --user=$user --password=$pwd  --no-timestamp  --incremental  /backup/xtra_inc_$dt --incremental-basedir=/backup/xtra_inc_$lastday > /tmp/$log 2>&1   
        ;;  
esac 
find /tmp -mtime +6 -type f -name 'backuplog.*' -exec rm -rf {} \;
