MySQL 5.7 多主一从（多源复制）同步配置

https://mp.weixin.qq.com/s?__biz=MjM5NzM0MjcyMQ==&mid=2650085455&idx=2&sn=8c03a1b4e9320b4d137dd66eecccdc9e&chksm=bedac32189ad4a37c8bad60082f1d04bfe9608a800fb84476f01c874ba501e3ef16dd3c511af&mpshare=1&scene=1&srcid=  
  
两台mysql服务，  
主：192.168.10.16  
从：192.168.10.17  
  
主库配置  
在Linux环境下MySQL的配置文件的位置是在 /etc/my.cnf
，在该文件下指定Master的配置如下：  
[root\@linux6 \~]\# cat /etc/my.cnf  
[mysqld]  
\~\~\~  
log-bin=mysql-bin  
\# 标识唯一的数据库  
server-id=2  
\# 同步的时候忽略的库  
binlog-ignore-db=information_schema  
binlog-ignore-db=performance_schema  
binlog-ignore-db=mysql  
\#指定需要同步的库  
binlog-do-db=ceshi  
  
在主库上单独创建用户并赋予从库权限  
CREATE USER \`mysql\`\@\`192.168.10.17\`;  
GRANT REPLICATION SLAVE ON \*.\* TO \`mysql\`\@\`192.168.10.17\`;  
SET PASSWORD FOR \`mysql\`\@\`192.168.10.17\`=PASSWORD('mysql');  
FLUSH PRIVILEGES;  
  
重启mysql，登录mysql，显示主库信息  
mysql\> show master status;  
+------------------+----------+--------------+---------------------------------------------+-------------------+  
\| File \| Position \| Binlog_Do_DB \| Binlog_Ignore_DB \| Executed_Gtid_Set \|  
+------------------+----------+--------------+---------------------------------------------+-------------------+  
\| mysql-bin.000001 \| 2138 \| ceshi \|
information_schema,performance_schema,mysql \| \|  
+------------------+----------+--------------+---------------------------------------------+-------------------+  
1 row in set (0.00 sec)  
  
从库配置  
[root\@linux7 \~]\# cat /etc/my.cnf  
[mysqld]  
\~\~\~  
log-bin=mysql-bin  
\# 唯一  
server-id=3  
\# 忽略的库  
replicate-ignore-db=information_schema  
replicate-ignore-db=performance_schema  
replicate-ignore-db=mysql  
\# 同步的库  
replicate-do-db=ceshi  
log-slave-updates  
slave-skip-errors=all  
slave-net-timeout=60  
  
重启mysql，登录从mysql，配置验证信息  
mysql -uroot -p  
stop slave;  
change master to master_host='192.168.10.16',  
master_user='mysql',  
master_password='mysql',  
\#主库show master status; 处得到  
master_log_file='mysql-bin.000002',  
master_log_pos=270;  
start slave;  
\#查看主从服务  
mysql\> show slave status\\G;  
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\* 1. row
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*  
Slave_IO_State: Waiting for master to send event  
Master_Host: 192.168.10.16  
Master_User: mysql  
Master_Port: 3306  
Connect_Retry: 60  
Master_Log_File: mysql-bin.000001  
Read_Master_Log_Pos: 402  
Relay_Log_File: linux7-relay-bin.000002  
Relay_Log_Pos: 565  
Relay_Master_Log_File: mysql-bin.000001  
Slave_IO_Running: Yes  
Slave_SQL_Running: Yes  
Replicate_Do_DB: ceshi  
Replicate_Ignore_DB: mysql  
Replicate_Do_Table:  
  
测试可得结果！！！  
  
PS：忽略某个库的复制有两个参数:  
binlog_ignore_db  
replicate-ignore-db  
区别:  
binlog_ignore_db参数是设置在主库上的,  
例如,binlog_ignore_db=test,那么针对test库下的所有操作都不会记录下来,  
这样slave在接收主库的binlog时文件量就会减少,这样可以减少网络I/O,减少slave端I/O线程的I/O量,从而最大幅度优化复制性能,有隐患。  
隐患:create table test.number3 like test.number;没有binlog日志记录,必须use
test,然后再执行就可以了  
  
replicate-ignore-db参数是设置在从库上的,  
例如,replicate-ignore-db=test,那么针对test库下的所有操作都不会被SQL线程执行,  
在安全上可以保证master和slave数据的一致性。  
如果想在slave上忽略一个库的复制,最好不要用binlog_ignore_db这个参数,使用replicate-ignore-db
= yourdb取代之。  
replicate_ignore_db也有隐患:原因是设置replicate_ignore_db后,MySQL执行sql前检查的是当前默认数据库,所以跨库更新语句在Slave上会被忽略。  
可以在Slave上使用 replicate_wild_do_table 和 replicate_wild_ignore_table
来解决跨库更新的问题,如:  
replicate_wild_do_table=test.%或replicate_wild_ignore_table=mysql.%
这样就可以避免出现上述问题了
