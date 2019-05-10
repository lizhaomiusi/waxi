#!/bin/bash
day=`date +%w`
dt=`date +%Y%m%d`
lastday=`date -d '1 days ago' +%Y%m%d`
lasttwoday=`date -d '2 days ago' +%Y%m%d`
lastthreeday=`date -d '3 days ago' +%Y%m%d`
user=root
pwd='xxxxxxx'
log=recoverlog.`date +%Y%m%d`
datefile=/mysqldata

case $day in  
    0)  
        # Sunday Recover Database 
        innobackupex --apply-log  /backup/xtra_base_$dt > /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$dt >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start
        binlog=`cat /backup/xtra_base_$dt/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$dt/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
    1)  
        # Monday Recover Database 
        innobackupex --apply-log --redo-only /backup/xtra_base_$lastday > /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lastday/ --incremental-dir=/backup/xtra_inc_$dt/ >> /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lastday >> /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$lastday >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start
        binlog=`cat /backup/xtra_base_$lastday/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$lastday/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
    2)  
        # Tuesday Recover Database
        innobackupex --apply-log --redo-only /backup/xtra_base_$lasttwoday > /tmp/$log 2>&1
        innobackupex --apply-log --redo-only /backup/xtra_base_$lasttwoday/ --incremental-dir=/backup/xtra_inc_$lastday/ >> /tmp/$log 2>&innobackupex --apply-log  /backup/xtra_base_$lasttwoday/ --incremental-dir=/backup/xtra_inc_$dt/ >> /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lasttwoday >> /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$lasttwoday >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start
        binlog=`cat /backup/xtra_base_$lasttwoday/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$lasttwoday/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
    3)  
        # Wednesday Recover Database 
        innobackupex --apply-log  /backup/xtra_base_$dt > /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$dt >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start 
        binlog=`cat /backup/xtra_base_$dt/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$dt/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
    4)  
        # Thursday  Recover Database 
        innobackupex --apply-log --redo-only /backup/xtra_base_$lastday > /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lastday/ --incremental-dir=/backup/xtra_inc_$dt/ >> /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lastday >> /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$lastday >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start 
        binlog=`cat /backup/xtra_base_$lastday/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$lastday/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
    5)  
        # Friday Recover Database  
        innobackupex --apply-log --redo-only /backup/xtra_base_$lasttwoday > /tmp/$log 2>&1
        innobackupex --apply-log --redo-only /backup/xtra_base_$lasttwoday/ --incremental-dir=/backup/xtra_inc_$lastday/ >> /tmp/$log 2>&innobackupex --apply-log  /backup/xtra_base_$lasttwoday/ --incremental-dir=/backup/xtra_inc_$dt/ >> /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lasttwoday >> /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$lasttwoday >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start
        binlog=`cat /backup/xtra_base_$lasttwoday/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$lasttwoday/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
    6)  
        # Saturday Recover Database  
        innobackupex --apply-log --redo-only /backup/xtra_base_$lastthreeday > /tmp/$log 2>&1
        innobackupex --apply-log --redo-only /backup/xtra_base_$lastthreeday/ --incremental-dir=/backup/xtra_inc_$lasttwoday/ >> /tmp/$log 2>&1
        innobackupex --apply-log --redo-only /backup/xtra_base_$lastthreeday/ --incremental-dir=/backup/xtra_inc_$lastday/ >> /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lastthreeday/ --incremental-dir=/backup/xtra_inc_$dt/ >> /tmp/$log 2>&1
        innobackupex --apply-log  /backup/xtra_base_$lastthreeday >> /tmp/$log 2>&1
        service mysqld stop
        rm -rf $datefile/*
        innobackupex --defaults-file=/etc/my.cnf --copy-back /backup/xtra_base_$lastthreeday >> /tmp/$log 2>&1
        chown -R mysql:mysql $datefile
        service mysqld start
        binlog=`cat /backup/xtra_base_$lastthreeday/xtrabackup_binlog_info|awk '{print $1}'`
        pos=`cat /backup/xtra_base_$lastthreeday/xtrabackup_binlog_info|awk '{print $2}'`
        mysqlbinlog --no-defaults --start-position=$pos /mysqllog/$binlog | mysql -u$user -p$pwd
        ;;  
esac 
find /tmp -mtime +6 -type f -name 'recoverlog.*' -exec rm -rf {} \;
