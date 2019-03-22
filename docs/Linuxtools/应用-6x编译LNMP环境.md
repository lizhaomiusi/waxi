搭建LNMP环境（CentOS 6）

操作系统：CentOS 6.8 64位

Nginx版本：Nginx 1.10.2

MySQL版本：MySQL 5.6.24

PHP版本：PHP 5.6.23

准备编译环境。

安装Nginx。

安装MySQL。

安装PHP-FPM。

测试访问。

步骤一：准备编译环境。

cat /etc/redhat-release查看系统版本。

关闭防火墙、SELinux。

步骤二：安装Nginx。

添加运行Nginx服务进程的用户。

groupadd -r nginx

useradd -r -g nginx nginx

下载源码包解压编译。

yum install epel-release -y

wget http://nginx.org/download/nginx-1.10.2.tar.gz

tar xvf nginx-1.10.2.tar.gz -C /usr/local/src

yum groupinstall "Development tools" -y

yum -y install gcc wget gcc-c++ automake autoconf libtool libxml2-devel
libxslt-devel perl-devel perl-ExtUtils-Embed pcre-devel openssl-devel

cd /usr/local/src/nginx-1.10.2

./configure \\

\--prefix=/usr/local/nginx \\

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

\--user=nginx \\

\--group=nginx \\

\--with-pcre \\

\--with-http_v2_module \\

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

\--with-mail \\

\--with-mail_ssl_module \\

\--with-file-aio \\

\--with-ipv6 \\

\--with-http_v2_module \\

\--with-threads \\

\--with-stream \\

\--with-stream_ssl_module

make && make install

mkdir -p /var/tmp/nginx/client

添加SysV启动脚本。

vi /etc/init.d/nginx

\#!/bin/sh

\#

\# nginx - this script starts and stops the nginx daemon

\#

\# chkconfig: - 85 15

\# description: Nginx is an HTTP(S) server, HTTP(S) reverse \\

\# proxy and IMAP/POP3 proxy server

\# processname: nginx

\# config: /etc/nginx/nginx.conf

\# config: /etc/sysconfig/nginx

\# pidfile: /var/run/nginx.pid

\# Source function library.

. /etc/rc.d/init.d/functions

\# Source networking configuration.

. /etc/sysconfig/network

\# Check that networking is up.

[ "\$NETWORKING" = "no" ] && exit 0

nginx="/usr/sbin/nginx"

prog=\$(basename \$nginx)

NGINX_CONF_FILE="/etc/nginx/nginx.conf"

[ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx

lockfile=/var/lock/subsys/nginx

start() {

[ -x \$nginx ] \|\| exit 5

[ -f \$NGINX_CONF_FILE ] \|\| exit 6

echo -n \$"Starting \$prog: "

daemon \$nginx -c \$NGINX_CONF_FILE

retval=\$?

echo

[ \$retval -eq 0 ] && touch \$lockfile

return \$retval

}

stop() {

echo -n \$"Stopping \$prog: "

killproc \$prog -QUIT

retval=\$?

echo

[ \$retval -eq 0 ] && rm -f \$lockfile

return \$retval

killall -9 nginx

}

restart() {

configtest \|\| return \$?

stop

sleep 1

start

}

reload() {

configtest \|\| return \$?

echo -n \$"Reloading \$prog: "

killproc \$nginx -HUP

RETVAL=\$?

echo

}

force_reload() {

restart

}

configtest() {

\$nginx -t -c \$NGINX_CONF_FILE

}

rh_status() {

status \$prog

}

rh_status_q() {

rh_status \>/dev/null 2\>&1

}

case "\$1" in

start)

rh_status_q && exit 0

\$1

;;

stop)

rh_status_q \|\| exit 0

\$1

;;

restart\|configtest)

\$1

;;

reload)

rh_status_q \|\| exit 7

\$1

;;

force-reload)

force_reload

;;

status)

rh_status

;;

condrestart\|try-restart)

rh_status_q \|\| exit 0

;;

\*)

echo \$"Usage: \$0
{start\|stop\|status\|restart\|condrestart\|try-restart\|reload\|force-reload\|configtest}"

exit 2

esac

赋予脚本执行权限。

chmod +x /etc/init.d/nginx

添加至服务管理列表，设置开机自启。

chkconfig --add nginx

chkconfig nginx on

启动服务。

service nginx start

查看测试

步骤三：安装MySQL。

准备编译环境。

yum groupinstall "Server Platform Development" "Development tools" -y

yum install cmake -y

准备MySQL数据存放目录。

mkdir /mnt/data

groupadd -r mysql

useradd -r -g mysql -s /sbin/nologin mysql

id mysql

更改数据目录属主和属组。

chown -R mysql:mysql /mnt/data

下载稳定版源码包解压编译。

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

\-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \\

\-DDEFAULT_CHARSET=utf8 \\

\-DDEFAULT_COLLATION=utf8_general_ci

make && make install

修改安装目录的属组为mysql。

chown -R mysql:mysql /usr/local/mysql/

初始化数据库。

cd /usr/local/mysql

/usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/mnt/data/

PS：说明 在CentOS
6.8版操作系统的最小安装完成后，在/etc目录下会存在一个my.cnf，需要将此文件更名为其他的名字，如/etc/my.cnf.bak，否则，该文件会干扰源码安装的MySQL的正确配置，造成无法启动。

复制配置文件和启动脚本。

cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld

chmod +x /etc/init.d/mysqld

mv /etc/my.cnf /etc/my.cnf.bak

cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

设置开机自动启动。

cd

chkconfig mysqld on

chkconfig --add mysqld

修改配置文件中的安装路径及数据目录存放路径。

echo -e "basedir = /usr/local/mysql\\ndatadir = /mnt/data\\n" \>\> /etc/my.cnf

设置PATH环境变量。

echo "export PATH=\$PATH:/usr/local/mysql/bin" \> /etc/profile.d/mysql.sh

source /etc/profile.d/mysql.sh

启动服务。

service mysqld start

mysql -h 127.0.0.1

步骤四：安装PHP-FPM。

Nginx作为web服务器，当它接收到请求后，不支持对外部程序的直接调用或者解析，必须通过FastCGI进行调用。如果是PHP请求，则交给PHP解释器处理，并把结果返回给客户端。PHP-FPM是支持解析PHP的一个FastCGI进程管理器。提供了更好管理PHP进程的方式，可以有效控制内存和进程、可以平滑重载PHP配置。

安装依赖包。

yum install epel-release -y

yum install libmcrypt libmcrypt-devel mhash mhash-devel libxml2 libxml2-devel
bzip2 bzip2-devel -y

下载稳定版源码包解压编译。

wget http://cn2.php.net/get/php-5.6.23.tar.bz2/from/this/mirror

cp mirror php-5.6.23.tar.bz2

tar xvf php-5.6.23.tar.bz2 -C /usr/local/src

cd /usr/local/src/php-5.6.23

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

添加PHP和PHP-FPM配置文件。

cp /usr/local/src/php-5.6.23/php.ini-production /etc/php.ini

cd /usr/local/php/etc/

cp php-fpm.conf.default php-fpm.conf

sed -i 's\@;pid = run/php-fpm.pid\@pid = /usr/local/php/var/run/php-fpm.pid\@'
php-fpm.conf

添加PHP-FPM启动脚本。

cp /usr/local/src/php-5.6.23/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm

chmod +x /etc/init.d/php-fpm

添加PHP-FPM至服务列表并设置开机自启。

chkconfig --add php-fpm

chkconfig --list php-fpm

chkconfig php-fpm on

启动服务。

service php-fpm start

添加Nginx对FastCGI的支持。

备份默认的Nginx配置文件。

mv /etc/nginx/nginx.conf /etc/nginx/nginx.confbak

cp /etc/nginx/nginx.conf.default /etc/nginx/nginx.conf

\#

输入命令vi
/etc/nginx/nginx.conf打开Nginx的配置文件，按下i键，在所支持的主页面格式中添加php格式的主页，类似如下：

location / {

root /usr/local/nginx/html;

index index.php index.html index.htm;

}

\# sed -i '44 s/html/\\/usr\\/local\\/nginx\\/html/' /etc/nginx/nginx.conf

\# sed -i '45 s/ index.html/index.php index.html/' /etc/nginx/nginx.conf

取消以下内容前面的注释：

location \~ \\.php\$ {

root html;

fastcgi_pass 127.0.0.1:9000;

fastcgi_index index.php;

fastcgi_param SCRIPT_FILENAME /scripts\$fastcgi_script_name;

include fastcgi_params;

}

\# sed -i '65,71 s/\#//' /etc/nginx/nginx.conf

将 root html;

改成 root /usr/local/nginx/html;

将 fastcgi_param SCRIPT_FILENAME /scripts\$fastcgi_script_name;

改成 fastcgi_param SCRIPT_FILENAME /usr/local/nginx/html/\$fastcgi_script_name;

\# sed -i '66 s/html/\\/usr\\/local\\/nginx\\/html/' /etc/nginx/nginx.conf

\# sed -i '69 s/\\/scripts/\\/usr\\/local\\/nginx\\/html\\//'
/etc/nginx/nginx.conf

输入命令service nginx reload重新载入Nginx的配置文件。

步骤五：测试访问

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

常见问题解决办法  
1.CentOS下如何完全卸载php文件  
注意：当我们使用命令：yum remove
php，是无法完全卸载php文件的，输入查看php版本命令：php -v，还是可以看到php版本。  
正确做法如下：（强制删除全部php软件包）

PS

查看全部php软件包  
rpm -qa\|grep php  
php-cli-5.3.3-22.el6.x86_64  
php-pdo-5.3.3-22.el6.x86_64  
php-gd-5.3.3-22.el6.x86_64  
php-fpm-5.3.3-22.el6.x86_64  
php-common-5.3.3-22.el6.x86_64  
php-5.3.3-22.el6.x86_64  
php-xml-5.3.3-22.el6.x86_64  
php-pear-1.9.4-4.el6.noarch  
  
以此卸载软件包（注意：卸载要先卸载没有依赖的）  
rpm -e php-fpm-5.3.3-22.el6.x86_64  
rpm-e php-pdo-5.3.3-22.el6.x86_64  
rpm -e php-pear-1.9.4-4.el6.noarch  
rpm-e php-cli-5.3.3-22.el6.x86_64  
rpm -e php-5.3.3-22.el6.x86_64  
rpm-e php-xml-5.3.3-22.el6.x86_64  
rpm -e php-gd-5.3.3-22.el6.x86_64  
rpm-e php-common-5.3.3-22.el6.x86_64  
再次输入查看php版本命令：php -v，版本信息已经没有提示，卸载成功。
