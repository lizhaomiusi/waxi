zabbix部署

1：首先搭建好LNMP或者LAMP环境  
2：安装zabbix或者nagios等工具，这里以zabbix为例。  
3：安装zabbix  
1：从zabbix下载最新的版本通过winscp上传到服务器。  
2：linux服务器iptables做一些端口放行设置，比如mysql的3306端口等，selinux关闭。  
3：创建用户组及用户，设置权限。  
  
groupadd zabbix  
useradd -g zabbix zabbix  
  
4：安装编译zabbix文件，做安装前的准备设置。 tar -xvf zabbix-3.2.0.tar.gz //解压  
cd /data/zabbix-3.2.0/database/mysql/ //导入3张表  
mysql -u zabbix -p zabbix \< schema.sql  
mysql -u zabbix -p zabbix \< images.sql  
mysql -u zabbix -p zabbix \< data.sql  
/configure --enable-server --with-mysql --enable-ipv6 --with-net-snmp
--with-libcurl --with-libxml2 --with- unixodbc --with-ssh2 --with-openipmi
--with-openssl //编译  
make install //安装

5：修改配置启动文件  
vim /usr/local/etc/zabbix_server.conf  
DBName=zabbix  
DBUser=zabbix  
DBPassword=zabbix

6：创建zabbix-web页面文件夹  
mkdir /var/www/html/zabbix  
cd /data/zabbix-3.2.0/frontends/php/  
cp -a . /var/www/html/zabbix/

7：设置Apache用户web接口文件的所有者并设置对应权限  
chown -R apache:apache /var/www/html/zabbix  
chmod +x /var/www/html/zabbix/conf/  
cp /data/zabbix-3.2.0/misc/init.d/fedora/core/zabbix_server
/etc/init.d/zabbix_server  
chkconfig --add /etc/init.d/zabbix_server

8：启用Zabbix服务器,Apache和MySQL服务启动  
chkconfig httpd on  
chkconfig mysqld on  
chkconfig zabbix_server on  
/etc/init.d/httpd start  
service zabbix_server start

9：设置php.ini参数  
vim /etc/php.ini  
post_max_size=16M  
max_execution_time=300  
max_input_time=300  
date.timezone=Asia/Shanghai  
always_populate_raw_post_data=-1  
/etc/init.d/httpd restart  
此时server端安装基本告一段落，web页面打开进行详细操作设置即可
