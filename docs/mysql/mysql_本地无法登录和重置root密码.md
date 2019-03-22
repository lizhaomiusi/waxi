mysql_本地无法登录和重置root密码

\#root账户被删除  
/etc/init.d/mysqld stop  
vi my.cnf  
[mysqld]  
\#该命令用完一定要删除  
skip-grant-tables  
  
/etc/init.d/mysqld restart  
\# mysql登录无密码  
\# 执行下面  
mysql  
use mysql;

\# 添加root账户  
insert into mysql.user (host, user,
password,ssl_cipher,x509_issuer,x509_subject) values ('%',
'root',password('root'),'','','');  
flush privileges;  
select user,host,password from mysql.user;  
授权all给root账户，并添加给账户赋权限功能  
grant all privileges on \*.\* to 'root'\@'%' identified by 'root' with grant
option;  
flush privileges;  
exit  
  
PS：如果直接添加用户会直接报错，解决办法  
mysql  
use mysql;  
insert into mysql.user(Host,User,Password) values("%","root",password("root"));  
flush privileges;  
grant all privileges on \*.\* to 'root'\@'%' identified by 'root' with grant
option;  
flush privileges;  
  
mysql\> insert into user(host,user,password)
values("localhost","peter1",password("123456"));  
ERROR 1364 (HY000): Field 'ssl_cipher' doesn't have a default value

原因：在我的配置文件my.cnf中有这样一条语句  
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

指定了严格模式，为了安全，严格模式禁止通过insert
这种形式直接修改mysql库中的user表进行添加新用户  
解决办法：  
将配置文件中的STRICT_TRANS_TABLES删掉，即改为：  
sql_mode=NO_ENGINE_SUBSTITUTION  
然后重启mysql即可  
  
\# Mysql本地无法登陆的情况  
\# 停止mysql数据库  
/etc/init.d/mysqld stop

\# 执行如下命令  
mysqld_safe --user=mysql --skip-grant-tables --skip-networking &  
mysql -u root mysql

\# 更新root密码  
use mysql;  
update user set password=password('root') where user='root' and host='%';  
select user,host,password from mysql.user;  
flush privileges;  
  
\# 给root用户所有权  
GRANT ALL on \*.\* to 'root'\@'%';  
flush privileges;

\# 最新版MySQL请采用如下SQL：  
UPDATE user SET authentication_string=PASSWORD('root') where USER='root';

\# 重启mysql  
/etc/init.d/mysqld restart

使用root用户重新登录mysql  
mysql -uroot -p  
Enter password:  
  
\# 如果root不可以给新用户赋权限了，解决办法

\# 查询root权限，可以看到Grant_priv: N  
select \* from mysql.user where user='root' and host='%'\\G;

\# 修改Grant_priv: Y  
update mysql.user set Grant_priv='Y' where User='root' and Host='%';  
flush privileges;
