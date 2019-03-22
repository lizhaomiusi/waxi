搭建owncloud

记一次部署开源私有存储owncloud环境一次过，此外下载PC端和手机端，别人都帮你做好了直接开用。  
  
环境centos7 apache mysql php5.6  
准备工作  
centos7 owncloud-10.0.7.zip  
关闭防火墙  
systemctl stop firewalld  
systemctl disable firewalld  
  
关闭selinux  
vi /etc/selinux/config  
把SELINUX=enforcing  
改成 SELINUX=disabled  
或者  
sed -i 's/SELINUX=.\*/SELINUX=disabled/g' /etc/selinux/config  
init 6重启  
  
安装环境  
yum install -y httpd php php-mysql mariadb-server mariadb sqlite php-dom
php-mbstring php-gd php-pdo  
  
启动apache  
systemctl restart httpd.service  
  
启动mysql  
systemctl restart mariadb.service  
  
登录mysql并自己设置mysql，下面安装的时候owncloud的时候  
登录并创建数据库和账户并赋权  
mysql  
MariaDB [(none)]\> use mysql;  
MariaDB [mysql]\> create database owncloud;  
修改root账户密码为root  
MariaDB [mysql]\> update mysql.user set password=password('root') where
User="root" and Host="%";  
MariaDB [mysql]\> flush privileges;  
MariaDB [mysql]\> exit;  
  
下载解压安装文件  
下载地址https://download.owncloud.org/community/owncloud-10.0.7.zip  
unzip owncloud-10.0.7.zip  
复制web文件到网站根目录下并赋权  
cp -r owncloud/\* /var/www/html/  
chown -R apache.apache /var/www/html/  
  
然后重启web的apache服务  
systemctl restart httpd.service  
  
浏览器访问该服务器地址  
访问报错  
This version of ownCloud requires at least PHP 5.6.0  
You are currently running PHP 5.4.16. Please update your PHP version.  
提示php版本低，php版本要求5.6以上  
升级php5.4到5.6版本，安装php仓库  
rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm  
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm  
若无响应多执行几次  
  
删除原有的php5.4  
yum remove php-common -y  
安装php5.6 根据需要添加扩展  
yum install -y php56w php56w-opcache php56w-xml php56w-mcrypt php56w-gd
php56w-devel php56w-mysql php56w-intl php56w-mbstring  
重启web环境  
systemctl restart httpd  
netstat -ntlp \# 查看服务端口是否都开启，提示没有命令\# yum install net-tools
-y安装  
查看php  
\# php -v  
PHP 5.6.36 (cli) (built: May 18 2018 04:51:01)  
再次访问web界面成功  
设置管理员账户密码  
下面填写数据库信息可选SQLite和mysql，我们选mysql将上面的设置填进去，点安装完成，耐心等待  
然后可以通过web登录，还可以下载PC端和手机端直接开用！！
