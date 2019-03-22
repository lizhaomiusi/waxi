centos6编译安装mysql  
环境：  
1、操作系统：CentOS release 6.8 (Final)  
2、安装版本： mysql-5.6.42-linux-glibc2.12-x86_64.tar.gz  
3、下载地址：https://dev.mysql.com/downloads/mysql/5.6.html\#downloads
\<https://dev.mysql.com/downloads/mysql/5.6.html\>  
  
卸载老版本MySQL  
查找并删除mysql有关的文件  
find / -name mysql \| xargs rm -rf  
  
下载  
wget
\<https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.42-linux-glibc2.12-x86_64.tar.gz\>  
  
在安装包存放目录下执行命令解压文件：  
tar -zxvf mysql-5.6.42-linux-glibc2.12-x86_64.tar.gz  
复制解压后的mysql目录到系统的本地软件目录，或者创建快捷方式  
生产用复制方式  
cp mysql-5.6.42-linux-glibc2.12-x86_64.tar.gz /usr/local/mysql -r  
ln -s /root/mysql-5.6.42-linux-glibc2.12-x86_64 /usr/local/mysql  
  
安装依赖  
yum -y install perl perl-devel autoconf libaio  
  
添加mysql用户组和mysql用户  
先检查是否有mysql用户组和mysql用户  
groups mysql  
  
若无，则添加；禁止用户登录用-s  
groupadd mysql  
useradd -r -g mysql -s /bin/false mysql  
  
进入安装mysql软件目录，修改目录拥有者为mysql用户  
cd /usr/local/mysql/  
chown -R mysql:mysql ./  
  
安装数据库，此处可能出现错误。  
  
./scripts/mysql_install_db --user=mysql  
  
\# FATAL ERROR: please install the following Perl modules before executing
scripts/mysql_install_db:  
\# Data::Dumper  
  
\# 解决方法：  
yum install -y perl-Data-Dumper  
  
安装完之后修改当前目录拥有者为root用户，修改data目录拥有者为mysql  
chown -R root:root ./  
chown -R mysql:mysql ./data  
  
添加mysql服务开机自启动  
添加开机启动，把启动脚本放到开机初始化目录。  
cp support-files/mysql.server /etc/init.d/mysql  
\# 赋予可执行权限  
chmod +x /etc/init.d/mysql  
\# 添加服务  
chkconfig --add mysql  
\# 显示服务列表  
chkconfig --list \|grep mysql  
  
启动mysql服务  
  
\#创建缺少的文件夹  
mkdir /var/log/mariadb  
/etc/init.d/mysql start  
  
Starting MySQL. SUCCESS!  
  
把mysql客户端放到默认路径  
ln -s /usr/local/mysql/bin/mysql /usr/local/bin/mysql  
注意：建议使用软链过去，不要直接包文件复制，便于系统安装多个版本的mysql  
  
通过使用 mysql -uroot -p
连接数据库（默认数据库的root用户没有密码，这个需要设置一个密码）。  
错误信息：ERROR 2002 (HY000): Can't connect to local MySQL server through socket
'/tmp/mysql.sock' (2)  
  
解决方法：打开/etc/my.cnf,看看里面配置的socket位置是什么目录。  
socket=/var/lib/mysql/mysql.sock  
路径和“/tmp/mysql.sock”不一致。建立一个软连接或者修改路径：  
ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock  
  
到这里完成。  
去除匿名用户  
  
\# 测试匿名用户登录  
mysql -ux3  
  
可以看到匿名用户可以登录，具有information_schema和test库的相关权限。  
\# 删除匿名用户，使用root用户登录数据库  
delete from mysql.user where User='';  
flush privileges;
