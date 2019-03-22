搭建zabbix

http://www.zabbix.org.cn/ zabbix中文社区  
https://www.zabbix.com/documentation/3.4/zh/manual 3.4手册  
  
环境centos7 zabbix 3.2.11  
https://www.jb51.net/article/131206.htm

准备工作  
关闭防火墙和关闭selinux搭建zabbix  
systemctl stop firewalld.service  
systemctl disable firewalld.service  
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config  
grep SELINUX=disabled /etc/selinux/config  
setenforce 0  
  
安装rpm库配置部署包，之后就可以直接yum安装  
rpm包下载地址 http://repo.zabbix.com/zabbix/  
  
安装Zabbix部署包  
使用Mysql数据库安装Zabbix server、WEB前端  
rpm -ivh
http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm  
yum install zabbix-server-mysql zabbix-web-mysql -y  
  
\# 安装zabbix-agent，被监控端，到时候需要监控哪台就安装哪台(可选安装)  
\# 7系列  
rpm -ivh
http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm  
\# 6系列  
rpm -ivh
http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm  
yum install zabbix-agent -y  
systemctl enable zabbix-agent  
  
安装mysql数据库 centos7下的mysql叫mariadb  
yum install mariadb mariadb-server -y  
systemctl enable mariadb  
systemctl start mariadb  
  
登录mysql并创建zabbix用户和zabbix数据库  
mysql  
use mysql;  
grant all on zabbix.\* to zabbix\@'localhost' identified by "zabbix";  
CREATE DATABASE \`zabbix\` CHARACTER SET utf8 COLLATE utf8_general_ci;  
exit  
  
在MySQL上安装Zabbix数据库和用户，然后导入初始架构（Schema）和数据。  
cd /usr/share/doc/zabbix-server-mysql-3.2.11/  
zcat create.sql.gz \| mysql -uroot zabbix  
\# 若设密码自行添加-p参数  
  
修改zabbix_server.conf中编辑数据库配置  
vi /etc/zabbix/zabbix_server.conf  
DBHost=localhost  
DBName=zabbix  
DBUser=zabbix  
DBPassword=zabbix  
  
启动Zabbix Server进程  
systemctl enable zabbix-server  
systemctl restart zabbix-server  
  
修改zabbix的php配置  
Zabbix前端的Apache配置文件位于,一些PHP设置已经完成了配置.  
vi /etc/httpd/conf.d/zabbix.conf  
php_value max_execution_time 300  
php_value memory_limit 128M  
php_value post_max_size 16M  
php_value upload_max_filesize 2M  
php_value max_input_time 300  
php_value always_populate_raw_post_data -1  
\# php_value date.timezone Europe/Riga  
  
取消 “date.timezone” 设置的“\#”注释，修改配置。如：  
php_value date.timezone Asia/Shanghai  
  
在配置文件更改后，需要重启相关服务 开机自启  
systemctl enable mariadb  
systemctl enable httpd  
systemctl enable zabbix-server  
systemctl restart httpd  
systemctl restart zabbix-server  
systemctl restart zabbix-agent  
  
netstat -ntlp \# 查看端口  
zabbix前端可以在浏览器中通过地址进行访问。  
http://ip/zabbix  
  
需要配置数据库信息，passwd=zabbix填写进去，其他默认  
默认的用户名／密码为Admin/zabbix  
进入界面右上角人头像-选择Language-选择Chinese切换到中文  
  
如果故障查看日志  
tailf /var/log/zabbix/zabbix_server.log  
根据提示解决问题
