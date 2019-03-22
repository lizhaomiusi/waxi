mysql数据库定期自动备份脚本

\#!/bin/bash

path="/usr/local/mysql/bin"

path2="/home"

user="root"

passwd="\*\*\*\*\*\*8"

dbname="xxxxx"

host="127.0.0.1"

today=\`date +%Y%m%d\`

sqlname=\$dbname\$today.sql

\#backup

mysqldump -h\$host -u\$user -p\$passwd \$dbname \>\$path2/\$sqlname

设置定时任务：

crontab -e进入编辑模式

输入30 1 \* \* 2 /bin/sh
/home/scripts/mysql_backup.sh（每星期二1点30分执行脚本）

第一次的话按CTRL+X 后按Y保存退出

启动cron服务：

service cron restart

检查是否自动备份
