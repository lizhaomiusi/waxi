MySQL复制环境Slave故障

处理一则MySQL Slave环境出现ERROR 1201 (HY000): Could not initialize master info
structure。

冷备份方式复制一份新的slave，初始化参数中已经修改了相关文件路径及server_id等关联参数。

但在启动slave时发现error_log中出现下列错误信息：

120326 11:10:23 [ERROR] /usr/local/mysql//libexec/mysqld: File
'/data/mysqldata/3306/binlog/mysql-relay-bin.000002' not found (Errcode: 2)

120326 11:10:23 [ERROR] Failed to open log (file
'/data/mysqldata/3306/binlog/mysql-relay-bin.000002', errno 2)

120326 11:10:23 [ERROR] Failed to open the relay log
'/data/mysqldata/3306/binlog/mysql-relay-bin.000002' (relay_log_pos 126074557)

120326 11:10:23 [ERROR] Could not open log file

120326 11:10:23 [ERROR] Failed to initialize the master info structure

由于新的slave改变了服务端口和文件路径，分析应该是由于mysql-relay-bin.index中仍然保存着旧relay日志文件的路径，而这些路径下又找不到合适的文件，因此报错。

对于这类问题解决起来是比较简单的，重置slave的参照即可，执行命令如下：

mysql\> reset slave;

Query OK, 0 rows affected (0.01 sec)

mysql\> change master to

\-\> master_host='10.0.0.101',

\-\> master_port=3306,

\-\> master_user='repl',

\-\> master_password='repl',

\-\> master_log_file='mysql-bin.000011',

\-\> master_log_pos=1;

ERROR 29 (HY000): File '/data/mysqldata/3306/binlog/mysql-relay-bin.000001' not
found (Errcode: 2)

看来应该还是mysql-relay-bin.index的问题，删除该文件及关联的relay-bin文件。再次配置master：

mysql\> change master to

\-\> master_host='10.0.0.101',

\-\> master_port=3306,

\-\> master_user='repl',

\-\> master_password='repl',

\-\> master_log_file='mysql-bin.000011',

\-\> master_log_pos=1;

ERROR 1201 (HY000): Could not initialize master info structure; more error
messages can be found in the MySQL error log

出现了新的错误，按照提示查看error_log也没发现更多错误信息,error_log中只是显示一条：

120326 11:14:27 [ERROR] Error reading master configuration

在操作系统端查看master/slave的配置文件，发现是两个0字节文件：

\-rw-rw---- 1 mysql mysql 0 Mar 26 11:13 master.info

\-rw-rw---- 1 mysql mysql 0 Mar 26 11:13 relay-log.info

会不会是这个原因呢，直接删除这两个文件，然后尝试重新执行change master：

mysql\> change master to

\-\> master_host='10.0.0.101',

\-\> master_port=3306,

\-\> master_user='repl',

\-\> master_password='repl',

\-\> master_log_file='mysql-bin.000011',

\-\> master_log_pos=1;

Query OK, 0 rows affected (0.00 sec)

成功，启动slave并查看状态：

mysql\> start slave;

Query OK, 0 rows affected (0.00 sec)

mysql\> show slave status\\G

\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\* 1. row
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

Slave_IO_State: Waiting for master to send event

Master_Host: 10.0.0.101

Master_User: repl

Master_Port: 3306

Connect_Retry: 60

Master_Log_File: mysql-bin.000011

Read_Master_Log_Pos: 101

...........

故障解决。
