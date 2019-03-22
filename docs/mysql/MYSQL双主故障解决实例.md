MYSQL双主故障解决。

根据报错得知，获取到的主库文件格式错误。

一、锁住主从正常的库

Mysql\> flush tables with read lock; 锁表

unlock tables; 解锁

SHOW MASTER STATUS;

主mysql添加用户给从服务器连接用：GRANT REPLICATION SLAVE ON \*.\* TO 'rep'\@'%'
IDENTIFIED BY 'logzgh' ;

二、关闭从库的主从：slave stop;

mysql\> CHANGE MASTER TO

MASTER_HOST='qa-sandbox-1′, IP地址

MASTER_USER='rep', 用户名

MASTER_PASSWORD='logzgh', 密码

MASTER_LOG_FILE='mysql-bin.000007′, 位置名字

MASTER_LOG_POS=471632; 偏移量

重新开启从库的主从：slave start;

解锁主库：unlock tables; 解锁

show slave status\\G;

SHOW MASTER STATUS;

下面六项需要在slave上设置：

Replicate_Do_DB:设定需要复制的数据库,多个DB用逗号分隔

Replicate_Ignore_DB:设定可以忽略的数据库.

Replicate_Do_Table:设定需要复制的Table

Replicate_Ignore_Table:设定可以忽略的Table

Replicate_Wild_Do_Table:功能同Replicate_Do_Table,但可以带通配符来进行设置。

Replicate_Wild_Ignore_Table:功能同Replicate_Do_Table,功能同Replicate_Ignore_Table,可以带通配符。

优点是在slave端设置复制过滤机制,可以保证不会出现因为默认的数据库问题而造成Slave和Master数据不一致或复制出错的问题.

缺点是性能方面比在Master端差一些.原因在于:不管是否须要复制,事件都会被IO线程读取到Slave端,这样不仅增加了网络IO量,也给Slave端的IO线程增加了Relay
Log的写入量。
