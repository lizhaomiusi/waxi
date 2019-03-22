应用-6X-LNMP安装与部署

一、准备工作

1、配置防火墙，开启80端口、3306端口

vim /etc/sysconfig/iptables

\-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT

\#允许80端口通过防火墙

\-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT

\#允许3306端口通过防火墙

正确的应该是添加到默认的22端口这条规则的下面

保存，并重启iptables

/etc/init.d/iptables restart

2、关闭SELINUX (最好关闭掉)

vim /etc/selinux/config

\#SELINUX=enforcing \#注释掉

\#SELINUXTYPE=targeted \#注释掉

SELINUX=disabled \#增加

:wq \#保存退出

shutdown -r now \#重启系统

或者临时关闭：

\$ sudo setenforce 0

\$ sestatus

3、安装C编译器:

yum -y install gcc gcc-c++ autoconf automake

4、安装第三方yum源

sohu源地址(64位源)：http://mirrors.sohu.com/fedora-epel/6/x86_64/

centos 6.X 64位：

rpm -Uvh
http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

rpm -ivh
http://mirrors.sohu.com/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm

二、安装mysql

1、先卸载系统自带的apache，然后更新软件库

yum -y remove httpd

yum update

2、yum安装mysql

这里直接安装

yum -y install mysql-server

3、加入启动项并启动mysql

chkconfig --levels 235 mysqld on

/etc/init.d/mysqld start

4、设置mysql密码及相关设置

/usr/bin/mysqladmin -u root password '123456'

第一次，为root账号设置密码

也可参考：

mysql_secure_installation

因为第一次启动这命令，所以直接回车下一步，然后输入你的mysql密码，按照提示操作。

三、安装nginx

1、yum安装nginx

yum -y install nginx

2、添加到启动项并启动nginx

chkconfig --levels 235 nginx on

/etc/init.d/nginx start

四、安装php

PHP包地址：http://webtatic.com/packages/php55/

这里使用 Webtatic EL6的YUM源来安装php5.5

建议安装前，先卸载以前的php再进行安装，使用：

yum remove php php-\*

CentOS/RHEL 7.x:

yum install epel-release

rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

CentOS/RHEL 6.x:

yum install epel-release

rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm

CentOS/RHEL 5.x:

rpm -Uvh https://mirror.webtatic.com/yum/el5/latest.rpm

安装php5.5

yum -y install php55w php55w-common php55w-mysql php55w-fpm php55w-gd
php55w-imap php55w-mbstring php55w-mcrypt php55w-pdo php55w-soap php55w-tidy
php55w-xml php55w-xmlrpc php55w-devel php55w-pgsql

安装php5.6

yum -y install php56w php56w-common php56w-mysql php56w-fpm php56w-gd
php56w-imap php56w-mbstring php56w-mcrypt php56w-pdo php56w-soap php56w-tidy
php56w-xml php56w-xmlrpc php56w-devel php56w-mysql php56w-pdo php56w-pgsql

安装php7.1

yum -y install mod_php71w php71w-common php71w-mysql php71w-fpm php71w-gd
php71w-imap php71w-mbstring php71w-mcrypt php71w-pdo php71w-soap php71w-tidy
php71w-xml php71w-xmlrpc php71w-pecl-redis php71w-pecl-memcached php71w-intl
php71w-bcmath php71w-pgsql

方便的地方是PHP版本任由自己选择

五、相关配置

1、PHP配置

\<1\> 编辑文件php.in

vim /etc/php.ini

修改：

short_open_tag = On

error_reporting = E_ALL & \~E_DEPRECATED & \~E_STRICT & \~E_NOTICE

date.timezone = PRC

request_order = "CGP"

保存

\<2\> 启动php-fpm

service php-fpm start

\<3\> php-fpm加入启动项

chkconfig --levels 235 php-fpm on

修改nginx配置文件，添加fastcgi支持

2、nginx配置

修改nginx.conf文件

vi /etc/nginx/nginx.conf

\<1\>配置文件部分代码：

server{

listen 80;

root /home/www/test;

index index.php index.html index.htm;

server_name www.test.cc;

if (!-e \$request_filename) {

rewrite \^(.\*)\$ /index.php?s=\$1 last;

break;

}

try_files \$uri \$uri/ /index.php?\$args;

\#try_files \$uri \$uri/ /index.php?s=\$uri;

location \~ .php {

fastcgi_pass 127.0.0.1:9000;

\#fastcgi_pass unix:/var/run/php5-fpm.sock;

fastcgi_index index.php;

fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

include fastcgi_params;

}

}

\<2\>重启nginx php-fpm

/etc/init.d/nginx restart

/etc/init.d/php-fpm restart

\<3\> 建立info.php文件

vi /usr/share/nginx/html/info.php

添加如下代码：

\<?php

phpinfo();

?\>
