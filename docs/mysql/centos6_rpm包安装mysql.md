linux CentOS6.5 yum安装mysql 5.6

\# https://www.cnblogs.com/Kaivenblog/p/5764583.html  
\# 需要检测系统是否自带安装mysql  
yum list installed \| grep mysql  
  
\# 如果发现有系统自带mysql，果断这么干  
yum -y remove mysql-libs.x86_64  
  
\#
随便在你存放文件的目录下执行，这里解释一下，由于这个mysql的yum源服务器在国外，所以下载速度会比较慢，还好mysql5.6只有79M大，而mysql5.7就有182M了，所以这是我不想安装mysql5.7的原因  
wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm  
  
\#
接着执行这句,解释一下，这个rpm还不是mysql的安装文件，只是两个yum源文件，执行后

\# 在/etc/yum.repos.d/ 这个目录下多出

\# mysql-community-source.repo  
\# mysql-community.repo  
rpm -ivh mysql-community-release-el6-5.noarch.rpm  
  
\# 这个时候，可以用yum repolist mysql这个命令查看一下是否已经有mysql可安装文件  
yum repolist all \| grep mysql  
  
\# 安装mysql 服务器命令（一路yes）：  
yum install mysql-community-server -y  
  
\# 安装成功后  
service mysqld start  
  
\# 设置开启自启动命令  
chkconfig --list \| grep mysqld  
chkconfig mysqld on  
  
\# mysql安全设置(系统会一路问你几个问题，看不懂复制之后翻译，基本上一路yes)：  
mysql_secure_installation  
  
\# 可以手动配置  
\#
由于mysql刚刚安装完的时候，mysql的root用户的密码默认是空的，所以我们需要及时用mysql的root用户登录（第一次回车键，不用输入密码），  
\# 配置远程登录  
mysql -u root  
use mysql;  
update user set host = '%' where user = 'root';  
select user,host,password from mysql.user;  
flush privileges;

\# 修改密码  
update user set password=password("root") where user='root';  
flush privileges;
