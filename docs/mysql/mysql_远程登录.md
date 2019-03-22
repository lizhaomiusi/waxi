mysql_远程登录  
允许远程用户登录访问mysql的方法  
需要手动增加可以远程访问数据库的用户。  
  
方法1、本地登入mysql，修改 "mysql" 数据库里的 "user" 表里的 "host"
项，将"localhost"改为"%"  
mysql -u root -p  
use mysql;  
update user set host = '%' where user = 'root';  
select user,host,password from mysql.user;  
flush privileges;  
  
方法2、直接授权账户和密码  
mysql -h localhost -u root -p  
use mysql;  
grant all privileges on \*.\* to 'root'\@'%' identified by 'root' with grant
option;  
select user,host,password from mysql.user;  
flush privileges;  
  
grant all privileges on \*.\* to mysql\@'%' identified by 'mysql';  
select user,host,password from mysql.user;  
flush privileges;
