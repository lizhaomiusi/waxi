binlog日志简介:

binlog 就是binary
log，二进制日志文件，这个文件记录了MySQL所有的DDL和DML(除了数据查询语句)语句，以事件形式记录，还包含语句所执行的消耗的时间。  
binlog日志包括两类文件：  
1）二进制日志索引文件（文件名后缀为.index）：用于记录所有的二进制文件；  
2）二进制日志文件（文件名后缀为.00000\*）：记录数据库所有的DDL和DML(除了数据查询语句select)语句事件。  
binlog日志对于mysql数据库来说是十分重要的。在数据丢失的紧急情况下，可以尝试用binlog日志功能进行数据恢复操作。  
正是由于binlog日志以上的特性，在实际的案件取证中也可以通过binlog日志来恢复删除数据。  
要通过binlog日志恢复mysql数据库删除数据的前提：binlog日志确定是开启的。  
查看binlog日志是否开启,有以下三种方法  
  
方法一：  
打开MySQL数据库的配置文件  
在配置文件中查看有没有log-bin=MySQL-bin  
[mysqld]  
...  
log-bin=MySQL-bin  
  
方法二：  
在MySQL命令行下使用show variables like ‘log_bin’;命令查看binlog日志是否开启，  
Value的值为ON表示开启，为OFF表示关闭。  
  
mysql\> show variables like 'log_bin';  
+---------------+-------+  
\| Variable_name \| Value \|  
+---------------+-------+  
\| log_bin \| ON \|  
+---------------+-------+  
1 row in set (0.00 sec)  
  
方法三：  
在存放data的文件夹中是否存在mysql-bin.000001类似的文件，有则表示binlog日志功能是开启的。  
  
在数据恢复过程中会用到的binlog日志操作命令  
1、查看所有binlog日志列表：  
在mysql命令界面输入命令：  
show master logs;  
  
2、查看master状态，即最后(最新)一个binlog日志的编号名称及其最后一个操作事件pos结束点(Position)值：  
在mysql命令界面输入命令：  
show master status;  
  
3、刷新log日志，自此刻开始产生一个新编号的binlog日志文件：  
在mysql命令界面输入命令：  
flush logs;  
注：每当mysqld服务重启时，会自动执行此命令，刷新binlog日志；在mysqldump备份数据时加
-F 选项也会刷新binlog日志  
  
4、重置(清空)所有binlog日志：  
在mysql命令界面输入命令：  
reset master;  
  
如何读取binlog日志中的内容？  
1、使用mysqlbinlog自带查看命令法：  
注: binlog是二进制文件，普通文件查看器cat more vi等都无法打开，  
必须使用自带的 mysqlbinlog 命令查看binlog日志与数据库文件在同目录中。  
Mysql安装路径下的bin文件夹下输入以下命令：  
C:\\xamppmysqlin\>mysqlbinlog C:\\xamppmysqldatamysql-bin.000009  
  
2、上面这种办法读取出binlog日志的全文内容较多，不容易分辨查看pos点信息，这里介绍一种更为方便的查询命令在MySQL的命令界面：  
在mysql命令界面输入：  
show binlog events [IN 'log_name'] [FROM pos] [LIMIT [offset,] row_count];  
选项解析↓  
IN 'log_name'：指定要查询的binlog文件名(不指定就是第一个binlog文件)  
FROM pos：指定从哪个pos起始点开始查起(不指定就是从整个文件首个pos点开始算)  
LIMIT [offset,]：偏移量(不指定就是0)  
row_count：查询总条数(不指定就是所有行)  
  
删除数据案例及操作步骤:  
下面我们通过一个实例操作来完整查看「如何通过binlog日志恢复MySQL数据库删除数据。  
案例介绍:  
现有MySQL数据库，其中有名为test的数据库，其中没有任何的表，怀疑数据被删除，在该电脑中还发现了该数据库的备份，备份最后被修改的时间为2018-11-21
15:27:12。  
目的:  
查看是否有删除的操作，如有删除尝试恢复出删除的表的内容。  
思路分析:  
1、判断数据库是否开启了binlog日志的功能；  
2、通过binlog日志查询是否有删除的操作；  
3、若删除了数据，通过binlog日志恢复数据库中的内容。  
下图就是通过binlog日志实现增量恢复数据库删除数据的流程：  
  
01.判断数据库是否开启了binlog日志：  
在MySQL命令行下使用  
show variables like'log_bin';  
命令中log_bin的Value为ON，该数据库的binlog日志是开启的。  
  
02.判断数据库是否有被删除的操作：  
1）在mysql命令界面通过  
show master logs;  
命令查看binlog日志列表，发现一共有n条日志。  
  
2）在mysql命令界面通过命令  
show binlog events in 'MySQL-bin.000001';  
可以查看最后两条命令为  
"use 'test'；  
delete from t1，use 'test'；  
DROP TABLE 't1'";  
由此可判断出数据库test中t1表中的内容被清空了，并且把表也删除了。  
  
03.恢复数据库中删除的数据：  
1）由于表t1被删除了，没有该表的数据结构无法直接通过binlog日志来恢复删除的数据；但是我们在电脑中发现了该数据库的备份，直接还原后就可以得到表t1的数据结构。  
  
恢复出的数据结构  
2）备份最后修改时间为2018-11-21 15:27:12，MySQL-bin.000008的创建时间为2018‎-‎11‎-‎20
‏‎14:15:40，可以推断出备份后表t1的所有操作都在该日志中。  
3）在mysql命令界面使用命令show binlog events in
'mysql-bin.000008'；打开最后一个日志文件，找出开始和结尾的pos点，分别为：4和1223，如下图：  
4）提取日志文件该段落：  
在mysql安装界面的bin目录下输入一下命令：  
mysqlbinlog C:\\xamppdatamysql-bin.000008 --start-position=4
--stop-position=1223 -r
1.sql，该命令把日志文件中的所有语句提取到了bin目录下的1.sql中。  
5）通过分析该sql文件可以发现其中记录了每一条命令的执行的时间，找到备份创建时间2018-11-21
15:27:12之后的所有命令另存为2.sql。如下图：  
6）另存为2.sql后，把最后两条删除的命令去除，直接在数据库中运行，就可以恢复出表中的所有数据。

注意事项:  
1、在恢复之前一定要确认MySQL数据库的binlog日志是开启的；  
2、若把表删除一定要想办法把表的数据结构找到，这样才能准确的恢复出数据；  
3、binlog日志中是记录了每条语句的执行时间的，可以通过时间来恢复；  
4、在截取插入语句的时候一定要注意不要把最后一条删除的语句截取到，不然恢复的数据又会被删除。
