Linux虚拟主机管理系统wdcp  
https://www.wdlinux.cn/bbs/thread-57643-1-1.html  
  
安装方法(请使用纯净系统，即不带任何其它WEB环境的系统)  
1 只安装wdcp面板看看  
wget http://down.wdlinux.cn/in/install_v3.sh  
sh install_v3.sh  
  
2 和lanmp环境一起安装  
yum install -y wget  
wget http://dl.wdlinux.cn/files/lanmp_v3.2.tar.gz  
tar zxvf lanmp_v3.2.tar.gz  
sh lanmp.sh  
  
可选安装LNMP,LAMP,LNAMP,4全部安装(可切换)  
默认安装软件版本为：  
nginx-1.8.1  
apache-2.2.31  
mysql-5.5.54  
php-5.5.38  
memcache  
redis  
zend  
如需要自定义软件版本，后加cus,如下  
sh lanmp.sh cus  
  
如需PHP多版本共存指定使用功能，也需安装，如  
sh lib/phps.sh  
(共支持7个版本的PHP，如5.2.17/5.3.29/5.4.45/5.5.38/5.6.30/7.0.18/7.1.4)  
也可指定安装某一版本，如sh lib/phps.sh 5.2.17  
多版本的zend,redis,memcache,opcache.sh扩展支持安装  
sh lib/phps_zend.sh  
sh lib/phps_redis.sh  
sh lib/phps_memcache.sh  
默认安装全部PHP版本，也可指定安装某PHP版本，同上  
  
软件安装目录  
/www/wdlinux  
数据库文件目录  
/www/wdlinux/mysql/data  
  
支持组件  
zend,memcache,rewrite,pdo_mysql,mysqli等常用组件  
  
支持系统  
wdcp_v3 支持wdOS/CentOS5.x/6.x/7.x  
  
3 升级  
(3.0/3.1的升级)  
可后台直接升级  
或使用如下手动升级  
wget http://down.wdlinux.cn/in/update_v3.sh  
sh update_v3.sh  
备注：  
此升级只是升级wdcp的后台面板及功能  
对于WEB环境的软件需另外升级(无特别需求，WEB环境可不升级或根据需求有针对性的升级)  
(2.X的升级)  
可用安装方法1中所说方法  
关于从v2的升级  
对于使用v2的用户  
可以单独升级wdcp后台到v3的版本(只安装v3的后台系统就可以,千万不要全新安装，否则很麻烦)  
v2/v3升级到v3.2的单独安装多PHP的方法  
http://www.wdlinux.cn/bbs/thread-57646-1-1.html  
  
卸载方法  
rm -fr /www/wdlinux  
reboot  
  
wdcp后台的启动，重起，关闭方法  
service wdcp start  
service wdcp restart  
service wdcp stop  
  
多版本PHP的手动启动\|停止\|重起  
如:5.5  
/www/wdlinux/phps/55/bin/php-fpm start  
/www/wdlinux/phps/55/bin/php-fpm stop  
/www/wdlinux/phps/55/bin/php-fpm restart  
如是其它版本，把55替换为相应版本即可  
  
wdcp支持两种安装方式  
1 源码编译
此安装比较麻烦和耗时,一般是20分钟至一个小时不等,具体视机器配置情况而定  
2 RPM包安装 简单快速,下载快的话,几分钟就可以完成  
  
源码安装(ssh登录服务器,执行如下操作即可,需root用户身份安装)  
wget http://dl.wdlinux.cn/lanmp_laster.tar.gz  
tar zxvf lanmp_laster.tar.gz  
sh lanmp.sh  
默认安装N+A的引擎组合  
可安装多版本PHP更灵活应用,参考http://www.wdlinux.cn/bbs/thread-57643-1-1.html  
  
安装前,可先去演示站体验一番  
http://demo.wdlinux.cn  
admin/wdlinux.cn  
  
卸载(注意备份数据,否则后果自负)  
sh install.sh uninstall  
就可以  
  
RPM包安装 RPM包安装软件版本较老，建议使用源码安装更新的版本  
wget http://down.wdlinux.cn/in/lanmp_wdcp_ins.sh  
sh lanmp_wdcp_ins.sh  
就可以  
RPM包安装支持系统:CentOS 5.X/wdlinux_base 5.X/wdOS 1.0,CentOS 6.X
,32位,64位均支持  
  
卸载 (切记备份好数据)  
sh lanmp_wdcp_ins.sh uninstall  
就可以  
  
安装完后,默认的后台管理地址如下  
http://ip:8080  
用户名:admin 默认密码:wdlinux.cn  
mysql默认的管理用户名:root 默认密码:wdlinux.cn  
  
相关说明  
所有软件安装目录/www/wdlinux  
站点配置文件  
/www/wdlinux/nginx/conf/vhost  
/www/wdlinux/apache/conf/vhost  
数据库配置文件/www/wdlinux/etc/my.cnf  
数据库数据文件目录 /www/wdlinux/mysql/var 或 /www/wdlinux/mysql/data  
  
可能问题  
1 登录时提示超时,检查下系统时间是否为当前时间  
2 重装后重新打开IE，否则会有session错误提示的问题
