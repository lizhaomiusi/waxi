#!bin/bash
yum install -y wget unzip
# 创建临时文件夹
mkdir -p /tmp/lnmp
# 进入临时文件夹
cd /tmp/lnmp
# nginx安装openssl必须 >= 1.0.2
yum install openssl -y
yum update openssl -y
# 下载mysql、php源包和nginx安装包，均从官网下载
# wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
wget https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
#wget http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.12.2-1.el7_4.ngx.x86_64.rpm
wget http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.14.0-1.el7_4.ngx.x86_64.rpm
wget https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm
#安装刚才下载的包
rpm -ivh nginx-1.14.0-1.el7_4.ngx.x86_64.rpm 
yum install epel-release -y
rpm -ivh remi-release-7.rpm
rpm -ivh mysql80-community-release-el7-1.noarch.rpm
#安装yum配置工具
yum install yum-utils -y
#配置yum源使用mysql 5.7版本，php7.2版本
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum-config-manager --enable remi-php72
#安装php、php-fpm、mysql等必装包
yum install php php-fpm php-mbstring php-mysql php-gd php-xml curl mysql-server -y
#删除nginx默认配置文件
rm -rf /etc/nginx/*
#下载我修改的nginx配置文件
wget -P /etc/nginx https://www.houzhibo.com/lnmp/nginx.conf.tar.gz
tar -zxf /etc/nginx/nginx.conf.tar.gz -C /etc/nginx
#下载我修改的php、php-fpm配置文件
wget https://www.houzhibo.com/lnmp/php.tar.gz
tar -zxf php.tar.gz
#删除默认php、php-fpm配置文件
rm -rf /etc/php.ini
rm -rf /etc/php-fpm.d/*
cp www.conf /etc/php-fpm.d/
cp php.ini /etc/
#创建test站点目录
mkdir -p /usr/share/nginx/test
#404等自定义页面默认路径
mkdir -p /usr/share/nginx/test/404
#创建test站点日志存放文件夹
mkdir -p /Logs/nginx/test/
#创建test站点日志文件
touch /Logs/nginx/test/test.log
#设置php-fpm开机自启
chkconfig php-fpm on
#设置nginx开机自启
chkconfig nginx on
#设置mysql开机自启
chkconfig mysqld on
#关闭selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
#临时关闭firewalld、iptables，建议永久开放80端口
service firewalld stop
service iptables stop
#启动php-fpm服务
service php-fpm start
#启动nginx服务
service nginx start
#启动mysql服务
service mysqld start
#创建phpinfo文件
echo  '<?php phpinfo(); ?>' > /usr/share/nginx/test/test.php
#允许nginx创建phpsession回话
chown nginx.nginx /var/lib/php/session
mysqlpasswd=`cat /var/log/mysqld.log | grep -i 'password is generated for root@localhost'| awk -F ': ' '{print $2}'`
mysql_version=`mysql -V | awk '{print $5}'`
php_version=`php -v | grep 'PHP 7'`
#修改mysql默认密码
mysqladmin -uroot -p"$mysqlpasswd" password New_password@123
#下载phpmyadmin并安装
wget -P /tmp/lnmp https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip
unzip /tmp/lnmp/phpMyAdmin-4.8.2-all-languages.zip -d /usr/share/nginx > /dev/null
mv /usr/share/nginx/phpMyAdmin-4.8.2-all-languages /usr/share/nginx/phpmyadmin
wget -P /usr/share/nginx/phpmyadmin https://www.houzhibo.com/lnmp/config.inc.php.bak
mv /usr/share/nginx/phpmyadmin/config.inc.php.bak /usr/share/nginx/phpmyadmin/config.inc.php
chown -R nginx.nginx /usr/share/nginx/phpmyadmin
#清除安装时升成的临时文件
rm -rf /tmp/lnmp
echo -e "\033[31mLNMP环境安装完成！相关服务设置为开机自启动。默认nginx日志路径为 /var/log/nginx/；默认站点日志路径为 /Logs/nginx/test/test.log;请将你的php站点放置此路径 /usr/share/nginx/test'\033[0m"
echo -e "\033[31m关闭了您的selinux，如果不关闭重启机器后，nginx启动可能会出错！\033[0m"
echo -e "\033[31mmysql默认密码为New_password@123请及时修改密码！！！\033[0m"
echo -e "\033[31mmysql版本为$mysql_version\033[0m"
echo -e "\033[31mphp版本为$php_version\033[0m"
echo -e "\033[31mphpmyadmin版本为4.8.2\033[0m"
echo -e "\033[31mnginx版本为\033[0m"
nginx -v
echo -e "\033[31m在浏览器输入当前服务器http://ip/test.php查看phpinfo信息\033[0m"
echo -e "\033[31m在浏览器输入当前服务器http://ip/phpmyadmin登录phpmyadmin\033[0m"
echo -e "\033[31m临时关闭了您OS中的防火墙，重启失效。请您开放80端口。如果使用https请一并开放443端口，注意：如果供应商有安全组等策略，请将服务器供应商的安全组中开放80、443端口。\033[0m"
echo -e "\033[31m如果使用https请按照/etc/nginx/conf.d/test.conf中的注释提示去掉相应的注释，并按照配置中的路径设置证书文件。\033[0m"
