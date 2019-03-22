应用 LANMP部署

web服务器

主流架构

LNMP（Linux+Nginx+MySQL+PHP） \# php-fpm进程代理方式

LAMP（Linux+Apache+MySQL+PHP） \# php-fpm作为apache进程

nginx+tomcat \# 取代apache与tomcat结合

7x编译安装LNMP  
环境

操作系统：CentOS 7.4 64位

Nginx版本：Nginx 1.10.2

MySQL版本：MySQL 5.6.24

PHP版本：PHP 5.6.38

准备编译环境。

安装Nginx。

安装MySQL。

安装PHP-FPM。

测试访问。

准备编译环境

cat /etc/redhat-release

CentOS Linux release 7.4.1708 (Core)

关闭防火墙、SElinux

systemctl status firewalld

systemctl stop firewalld

systemctl disable firewalld

setenforce 0

安装Nginx

安装依赖包

yum install epel-release -y

yum groupinstall "Development tools" -y

yum install zlib-devel pcre-devel openssl-devel -y

yum install perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2
libxml2-devel gd gd-devel GeoIP GeoIP-devel -y

下载源码包解压编译

yum install wget -y

wget http://nginx.org/download/nginx-1.10.2.tar.gz

\#http://nginx.org/en/download.html

tar xvf nginx-1.10.2.tar.gz -C /usr/local/src

cd /usr/local/src/nginx-1.10.2

./configure --prefix=/etc/nginx \\

\--sbin-path=/usr/sbin/nginx \\

\--conf-path=/etc/nginx/nginx.conf \\

\--error-log-path=/var/log/nginx/error.log \\

\--http-log-path=/var/log/nginx/access.log \\

\--pid-path=/var/run/nginx.pid \\

\--lock-path=/var/run/nginx.lock \\

\--http-client-body-temp-path=/var/tmp/nginx/client \\

\--http-proxy-temp-path=/var/tmp/nginx/proxy \\

\--http-fastcgi-temp-path=/var/tmp/nginx/fcgi \\

\--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \\

\--http-scgi-temp-path=/var/tmp/nginx/scgi \\

\--user=nginx --group=nginx \\

\--with-pcre --with-http_v2_module \\

\--with-http_ssl_module \\

\--with-http_realip_module \\

\--with-http_addition_module \\

\--with-http_sub_module \\

\--with-http_dav_module \\

\--with-http_flv_module \\

\--with-http_mp4_module \\

\--with-http_gunzip_module \\

\--with-http_gzip_static_module \\

\--with-http_random_index_module \\

\--with-http_secure_link_module \\

\--with-http_stub_status_module \\

\--with-http_auth_request_module \\

\--with-mail --with-mail_ssl_module \\

\--with-file-aio \\

\--with-ipv6 \\

\--with-http_v2_module \\

\--with-threads \\

\--with-stream \\

\--with-stream_ssl_module

make && make install

mkdir -p /var/tmp/nginx/client

nginx -v可查看Nginx的版本号

添加运行Nginx服务进程的用户

useradd nginx

chown -R nginx:nginx /etc/nginx/

添加nginx.service启动配置文件。

cat \> /usr/lib/systemd/system/nginx.service \<\< \\EOF

[Unit]

Description=nginx - high performance web server

Documentation=https://nginx.org/en/docs/

After=network-online.target remote-fs.target nss-lookup.target

Wants=network-online.target

[Service]

Type=forking

PIDFile=/var/run/nginx.pid

ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf

ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf

ExecReload=/bin/kill -s HUP \$MAINPID

ExecStop=/bin/kill -s TERM \$MAINPID

[Install]

WantedBy=multi-user.target

EOF

启动Nginx服务并设置开机自动启动。

systemctl start nginx

systemctl enable nginx

访问浏览器测试环境

安装MySQL

准备编译环境。

yum install ncurses-devel bison gnutls-devel -y

yum install cmake -y

准备MySQL数据存放目录

mkdir /mnt/data

groupadd -r mysql

useradd -r -g mysql -s /sbin/nologin mysql

id mysql

更改数据目录属主和属组

chown -R mysql:mysql /mnt/data

下载稳定版源码包解压编译

wget https://downloads.mysql.com/archives/get/file/mysql-5.6.24.tar.gz

tar xvf mysql-5.6.24.tar.gz -C /usr/local/src

cd /usr/local/src/mysql-5.6.24

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \\

\-DMYSQL_DATADIR=/mnt/data \\

\-DSYSCONFDIR=/etc \\

\-DWITH_INNOBASE_STORAGE_ENGINE=1 \\

\-DWITH_ARCHIVE_STORAGE_ENGINE=1 \\

\-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \\

\-DWITH_READLINE=1 \\

\-DWITH_SSL=system \\

\-DWITH_ZLIB=system \\

\-DWITH_LIBWRAP=0 \\

\-DMYSQL_TCP_PORT=3306 \\

\-DDEFAULT_CHARSET=utf8 \\

\-DDEFAULT_COLLATION=utf8_general_ci \\

\-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \\

\-DWITH_SYSTEMD=1 \\

\-DINSTALL_SYSTEMD_UNITDIR=/usr/lib/systemd/system

make && make install

修改安装目录的属组为mysql

chown -R mysql:mysql /usr/local/mysql/

初始化数据库并复制配置文件

cd /usr/local/mysql

/usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/mnt/data/

mv /etc/my.cnf /etc/my.cnf.bak

cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

修改配置文件中的安装路径及数据目录存放路径

echo -e "basedir = /usr/local/mysql\\ndatadir = /mnt/data\\n" \>\> /etc/my.cnf

添加mysql.service启动配置文件

cat \> /usr/lib/systemd/system/mysql.service \<\< \\EOF

[Unit]

Description=MySQL Community Server

After=network.target

After=syslog.target

[Install]

WantedBy=multi-user.target

Alias=mysql.service

[Service]

User=mysql

Group=mysql

PermissionsStartOnly=true

ExecStart=/usr/local/mysql/bin/mysqld

TimeoutSec=600

Restart=always

PrivateTmp=false

EOF

设置PATH环境变量

echo "export PATH=\$PATH:/usr/local/mysql/bin" \> /etc/profile.d/mysql.sh

source /etc/profile.d/mysql.sh

设置开机启动MySQL。启动MySQL服务。

systemctl enable mysql

systemctl start mysql

mysql -h 127.0.0.1

步骤四：安装PHP-FPM

Nginx作为web服务器，当它接收到请求后，不支持对外部程序的直接调用或者解析，必须通过FastCGI进行调用。如果是PHP请求，则交给PHP解释器处理，并把结果返回给客户端。PHP-FPM是支持解析PHP的一个FastCGI进程管理器。提供了更好管理PHP进程的方式，可以有效控制内存和进程、可以平滑重载PHP配置。

安装依赖包。

yum install libmcrypt libmcrypt-devel mhash mhash-devel libxml2 libxml2-devel
bzip2 bzip2-devel -y

下载稳定版源码包解压编译。

wget http://cn2.php.net/get/php-5.6.38.tar.bz2/from/this/mirror

cp mirror php-5.6.38.tar.bz2

tar xvf php-5.6.38.tar.bz2 -C /usr/local/src

cd /usr/local/src/php-5.6.38

./configure --prefix=/usr/local/php \\

\--with-config-file-scan-dir=/etc/php.d \\

\--with-config-file-path=/etc \\

\--with-mysql=/usr/local/mysql \\

\--with-mysqli=/usr/local/mysql/bin/mysql_config \\

\--enable-mbstring \\

\--with-freetype-dir \\

\--with-jpeg-dir \\

\--with-png-dir \\

\--with-zlib \\

\--with-libxml-dir=/usr \\

\--with-openssl \\

\--enable-xml \\

\--enable-sockets \\

\--enable-fpm \\

\--with-mcrypt \\

\--with-bz2

make && make install

添加PHP和PHP-FPM配置文件

cp /usr/local/src/php-5.6.38/php.ini-production /etc/php.ini

cd /usr/local/php/etc/

cp php-fpm.conf.default php-fpm.conf

sed -i 's\@;pid = run/php-fpm.pid\@pid = /usr/local/php/var/run/php-fpm.pid\@'
php-fpm.conf

php-fpm.service启动配置文件

cat \> /usr/lib/systemd/system/php-fpm.service \<\< \\EOF

[Unit]

Description=The PHP FastCGI Process Manager

After=network.target

[Service]

Type=simple

PIDFile=/usr/local/php/var/run/php-fpm.pid ExecStart=/usr/local/php/sbin/php-fpm
--nodaemonize --fpm-config /usr/local/php/etc/php-fpm.conf

ExecReload=/bin/kill -USR2 \$MAINPID

PrivateTmp=true

[Install]

WantedBy=multi-user.target

EOF

启动PHP-FPM服务并设置开机自动启动

systemctl start php-fpm

systemctl enable php-fpm

启动服务。

service php-fpm start

添加Nginx对FastCGI的支持。

备份默认的Nginx配置文件。

cp /etc/nginx/nginx.conf /etc/nginx/nginx.confbak

cp nginx.conf.default nginx.conf.default.bak

cp /etc/nginx/nginx.conf.default /etc/nginx/nginx.conf

vi /etc/nginx/nginx.conf打开Nginx的配置文件

location / {

root /etc/nginx/html;

index index.php index.html index.htm;

}

取消以下内容前面的注释：

location \~ \\.php\$ {

root html;

fastcgi_pass 127.0.0.1:9000;

fastcgi_index index.php;

fastcgi_param SCRIPT_FILENAME /scripts\$fastcgi_script_name;

include fastcgi_params;

}

将root html;改成root /etc/nginx/html;

将fastcgi_param SCRIPT_FILENAME /scripts\$fastcgi_script_name;改成fastcgi_param
SCRIPT_FILENAME /etc/nginx/html/\$fastcgi_script_name;

输入命令systemctl restart nginx重新载入Nginx的配置文件。

测试访问

增加/usr/local/nginx/html/index.php内容如下

cat \> /usr/local/nginx/html/index.php \<\< \\EOF

\<?php

\$conn=mysql_connect('127.0.0.1','root','');

if (\$conn){

echo "LNMP platform connect to mysql is successful!";

}else{

echo "LNMP platform connect to mysql is failed!";

}

phpinfo();

?\>

EOF

提示：

LNMP platform connect to mysql is successful!

PHP Version 5.6.23
