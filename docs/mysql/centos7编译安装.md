Centos7安装并配置mysql5.6完美教程  
https://www.cnblogs.com/progor/archive/2018/01/30/8387301.html  
  
Centos7将默认数据库mysql替换成了Mariadb，对于我们这些还想使用mysql的开发人员来说并不是一个好消息。

然而，网上关于Linux安装mysql数据库的教程数不胜数，但是，大多教程都是漏洞百出。Centos7安装配置mysql5.6的教程。  
在接下来的mysql安装过程中，请一定保证自己当前所在目录是正确的!  
  
一、安装MySQL  
下载安装包mysql-5.6.34-linux-glibc2.5-x86_64.tar  
  
卸载系统自带的Mariadb  
[root\@localhost \~]\# rpm -qa\|grep mariadb \# 查询出来已安装的mariadb  
[root\@localhost \~]\# rpm -e --nodeps 文件名 \#
卸载mariadb，文件名为上述命令查询出来的文件  
  
删除etc目录下的my.cnf  
rm /etc/my.cnf  
  
添加mysql用户组和mysql用户  
先检查是否有mysql用户组和mysql用户  
groups mysql  
若无，则添加；禁止用户登录用-s  
groupadd mysql  
useradd -r -g mysql -s /bin/false mysql  
  
解压mysql  
cd /usr/local/  
tar -xvf mysql-5.6.34-linux-glibc2.5-x86_64.tar  
mv mysql-5.6.34-linux-glibc2.5-x86_64 mysql  
  
复制配置文件到/etc/my.cnf  
copy一份/usr/local/mysql/support-files/下的my-default.cnf文件到/etc下  
cp support-files/my-default.cnf /etc/my.cnf  
  
然后，配置/etc目录下的my.cnf文件  
[root\@localhost support-files]\# vim /etc/my.cnf

[mysql]  
\# 设置mysql客户端默认字符集  
default-character-set=utf8  
socket=/var/lib/mysql/mysql.sock  
  
[mysqld]  
skip-name-resolve  
\# 设置3306端口  
port = 3306  
socket=/var/lib/mysql/mysql.sock  
\# 设置mysql的安装目录  
basedir=/usr/local/mysql  
\# 设置mysql数据库的数据的存放目录  
datadir=/usr/local/mysql/data  
\# 允许最大连接数  
max_connections=200  
\# 服务端使用的字符集默认为8比特编码的latin1字符集  
character-set-server=utf8  
\# 创建新表时将使用的默认存储引擎  
default-storage-engine=INNODB  
lower_case_table_name=1  
max_allowed_packet=16M

\# 修改当前目录拥有着为mysql用户  
cd /usr/local/mysql  
chown -R mysql:mysql ./  
\#安装数据库注意路径  
./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql/
--datadir=/usr/local/mysql/data/  
  
注：若执行以上最后一个命令出现以下问题：  
FATAL ERROR: please install the following Perl modules before executing  
./scripts/mysql_install_db:Data::Dumper  
  
解决方法 ：安装autoconf库  
命令: yum -y install autoconf //此包安装时会安装Data:Dumper模块  
安装完成重新执行上述最后一个命令  
  
重新回到上述第三个命令继续操作：  
\# 修改当前data目录的拥有者为mysql用户  
chown -R root:root ./  
chown -R mysql:mysql ./data  
  
到此数据库安装完毕！  
  
二、配置MySQL  
1、授予my.cnf权限  
[root\@localhost \~]\# chmod 644 /etc/my.cnf  
设置开机自启动服务控制脚本：  
  
2、复制启动脚本到资源目录  
[root\@localhost mysql]\# cp ./support-files/mysql.server
/etc/rc.d/init.d/mysqld  
  
3、增加mysqld服务控制脚本执行权限  
[root\@localhost mysql]\# chmod +x /etc/rc.d/init.d/mysqld  
  
4、将mysqld服务加入到系统服务  
[root\@localhost mysql]\# chkconfig --add mysqld  
  
命令为:service mysqld start和service mysqld stop  
  
6、启动mysqld  
[root\@localhost mysql]\# service mysqld start  
  
8、以root账户登录mysql,默认是没有密码的  
[root\@localhost mysql]\# mysql -uroot -p  
要输入密码的时候直接回车即可。  
  
9、设置root账户密码为root（也可以修改成你要的密码）  
use mysql;  
update user set password=password('root') where user='root' and host='%';  
flush privileges;  
exit  
  
10、设置远程主机登录，直接授权  
mysql -h localhost -u root -p  
grant all privileges on \*.\* to root\@'%' identified by 'root';  
select user,host,password from mysql.user;  
flush privileges;  
exit  
  
好了，到此，在Centos 7上安装mysql5.6就完成了。

当然，centos 6上安装mysql也可按照如此操作。接下来，快去用Centos
7安装好的mysql去写写sql command吧！
