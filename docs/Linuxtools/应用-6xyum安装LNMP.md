使用yum安装LNMP步骤

PHP \# 包源 https://webtatic.com/packages/

环境  
\# cat /etc/redhat-release  
CentOS release 6.9 (Final)  
关闭防火墙和selinux  
\# /etc/init.d/iptables stop  
\# chkconfig iptables off  
  
\#
在部署LNMP环境之前，首先，用户需要安装Nignx服务器，MySQL数据库，以及PHP环境相关的开发包和库文件，若缺少开发包或库文件，会导致后续LNMP环境部署失败。  
执行如下命令，安装LNMP环境所需的开发包和库文件，若不安装，则会导致后续的LNMP环境安装失败。例如：openssl等  
  
yum install ntp make openssl openssl-devel pcre pcre-devel libpng libpng-devel
libjpeg-6b libjpeg-devel-6b freetype freetype-devel gd gd-devel zlib zlib-devel
gcc gcc-c++ libXpm libXpm-devel ncurses ncurses-devel libmcrypt libmcrypt-devel
libxml2 libxml2-devel imake autoconf automake screen sysstat compat-libstdc++-33
curl curl-devel -y  
  
\# 在真实的生产环境中，若用户的服务器中，已安装的apache、mysql、php。请执行命令  
yum remove mysql httpd php  
\# 卸载相关软件，否则系统原有软件会对部署的LNMP环境中数据有影响。  
\# 没有安装如上软件，因此，页面提示  
\# Package xx available, but not installed \# （xx为软件名，例如mysql 等）  
  
\# 安装的Nginx  
yum install nginx -y  
  
\# 编辑  
vi /etc/nginx/conf.d/default.conf  
\# 进入nginx配置文件的编辑页面。注释，其中监听为ipv6的配置。  
\# listen [::]:80 default_server;  
  
\# 启动nginx服务器  
service nginx start  
Starting nginx: [ OK ]  
nginx版本  
nginx -v  
nginx version: nginx/1.10.2  
\#开机启动nginx  
chkconfig nginx on  
  
\# 安装mysql  
\# 在安装MySQL之前，安装mysql及其组件mysql-server，mysql-devel。  
yum install mysql mysql-server mysql-devel -y  
  
\# 启动mysql  
service mysqld start  
Starting mysqld: [ OK ]  
mysql  
Welcome to the MySQL monitor. Commands end with ; or \\g.  
Your MySQL connection id is 2  
Server version: 5.1.73 Source distribution  
\# 开机启动mysql  
chkconfig mysqld on  
  
\# 安装PHP  
\# 安装php及其常用扩展包。若缺少扩展包，可能会导致php安装或运行失败。  
yum install php lighttpd-fastcgi php-cli php-mysql php-gd php-imap php-ldap
php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-mssql php-snmp
php-soap -y  
  
\# 安装PHP的相关组件。这样，可以使PHP支持MySQL、FastCGI模式。  
yum install php-tidy php-common php-devel php-fpm php-mysql -y  
  
\# 执行命令  
service php-fpm start  
\# 启动php-fpm，界面显示“OK”。由于Nginx是个轻量级的HTTP
server，必须借助第三方的FastCGI处理器才可以对PHP进行解析，PHP-FPM是一个第三方的FastCGI进程管理器，只用于PHP。  
php -v  
PHP 5.3.3 (cli) (built: Mar 22 2017 12:27:09)  
\# 开机启动php-fpm  
chkconfig php-fpm on  
  
\# 配置nginx支持php  
\#复制推荐到配置文件，源配置文件备份，  
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak  
cp /etc/nginx/nginx.conf.default /etc/nginx/nginx.conf  
  
\# 进入nginx配置文件的编辑页面，添加Nginx的fastcgi支持。  
vim /etc/nginx/nginx.conf  
将文件第45行修改为如下内容  
也就是首页支持php语言。添加index.php  
  
location / {  
root html;  
index index.php index.html index.htm;  
  
将文件的65-72行代码前的注释"\#"去掉  
并替换"root"和“fastcgi_param”参数值为如下内容。也就是，使用  
/usr/share/nginx/html  
作为网站根目录，进行访问。  
修改两个地方  
\# 如下  
  
location \~ \\.php\$ {  
root /usr/share/nginx/html; \#修改为网站根目录  
fastcgi_pass 127.0.0.1:9000;  
fastcgi_index index.php;  
fastcgi_param SCRIPT_FILENAME /usr/share/nginx/html\$fastcgi_script_name;
\#修改为网站根目录  
include fastcgi_params;  
}  
  
vim /etc/php.ini  
进入文件php.ini的编辑页面，在结尾的  
"；Local Variables："  
前添加如下内容。  
cgi.fix_pathinfo = 1  
\# 如下  
  
;sysvshm.init_mem = 10000  
  
cgi.fix_pathinfo = 1  
; Local Variables:  
; tab-width: 4  
; End:  
  
\# 重启Nginx和php-fpm服务器。修改的Nginx配置文件中的参数生效。  
service nginx restart  
service php-fpm restart  
完成LNMP环境  
  
创建一个info.php文件  
执行命令  
vim /usr/share/nginx/html/info.php  
\<?php  
phpinfo();  
?\>  
  
最后，测试nginx是否成功解析php。  
打开本地浏览器，在地址栏中输入：http://xxx.xxx.xx.xx/info.php，  
若页面显示php介绍信息，证明LNMP环境搭建成功。  
  
yum安装的目录都在/var/lib/下  
yum安装版本比较低 可以卸载下载对应的rpm包进行安装
