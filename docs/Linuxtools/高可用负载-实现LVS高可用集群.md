高可用负载-实现LVS高可用集群

实现LVS高可用集群  
  
实验主机  
虚拟IP:192.168.166.100  
CentOS 7.3 主服务器， IP：192.168.166.130  
CentOS 7.3-1 备份服务器，IP：192.168.166.132  
CentOS 6.9 IP：192.168.166.129  
CentOS6.9-1 IP：192.168.166.131  
注：在配置服务前需要注意几台主机的防火墙策略，和SELinux配置，可先关闭。  
  
主调度器配置  
yum -y install keepalived ipvsadm \#安装keepalived和LVS管理软件ipvsadm  
vim /etc/keepalived/keepalived.conf \#配置keepalived

! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1 \#邮件服务器的地址  
smtp_connect_timeout 30  
router_id CentOS7.3 \#主调度器的主机名  
vrrp_mcast_group4 224.26.1.1 \#发送心跳信息的组播地址  
  
}  
  
vrrp_instance VI_1 {  
state MASTER \#主调度器的初始角色  
interface eth0 \#虚拟IP工作的网卡接口  
virtual_router_id 66 \#虚拟路由的ID  
priority 100 \#主调度器的选举优先级  
advert_int 1  
authentication {  
auth_type PASS \#集群主机的认证方式  
auth_pass 123456 \#密钥,最长8位  
}  
virtual_ipaddress {  
192.168.166.100 \#虚拟IP  
}  
}  
  
virtual_server 192.168.166.100 80 { \#LVS配置段，VIP  
delay_loop 6  
lb_algo rr \#调度算法轮询  
lb_kind DR \#工作模式DR  
nat_mask 255.255.255.0  
\# persistence_timeout 50
\#持久连接，在测试时需要注释，否则会在设置的时间内把请求都调度到一台RS服务器上面  
protocol TCP  
sorry_server 127.0.0.1 80 \#Sorry server的服务器地址及端口  
\#Sorry server就是在后端的服务器全部宕机的情况下紧急提供服务。  
real_server 192.168.166.129 80 { \#RS服务器地址和端口  
weight 1 \#RS的权重  
HTTP_GET { \#健康状态检测方法  
url {  
path /  
status_code 200 \#状态判定规则  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
  
real_server 192.168.166.131 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
}

[root\@CentOS7.3 keepalived]\#systemctl start keepalived \#启动keepalived  
[root\@CentOS7.3 keepalived]\#ip a l eth0 \#查看虚拟路由绑定的网卡  
  
inet 192.168.166.100/32 scope global eth0 \#虚拟IP已经绑定在了eth网卡上  
  
备份调度器的配置  
yum -y install keepalived ipvsadm  
vi /etc/keepalived/keepalived.conf

! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1  
smtp_connect_timeout 30  
router_id CentOS7.3-1 \#备份调度器的主机名  
vrrp_mcast_group4 224.26.1.1 \#这个组播地址需与集群内的其他主机相同  
  
}  
  
vrrp_instance VI_1 {  
state BACKUP \#初始角色，备份服务器需设置为BACKUP  
interface eth0  
virtual_router_id 66 \#虚拟路由的ID一定要和集群内的其他主机相同  
priority 90 \#选举优先级，要比主调度器地一些  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 123456 \#密钥需要和集群内的主服务器相同  
}  
virtual_ipaddress {  
192.168.166.100  
}  
}  
\#余下配置和主服务器相同  
virtual_server 192.168.166.100 80 {  
delay_loop 6  
lb_algo rr  
lb_kind DR  
nat_mask 255.255.255.0  
\# persistence_timeout 50  
protocol TCP  
sorry_server 127.0.0.1 80  
  
real_server 192.168.166.129 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
  
real_server 192.168.166.131 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
}

systemctl start keepalived \#启动备份keepalived  
ip a l eth0 \#查看虚拟路由绑定的网卡接口  
  
测试虚拟IP地址漂移  
关闭主服务器的keepalived，并查看eth0接口  
查看备份服务器的eth0接口，地址已经漂移到了备份服务器上面  
可以看到上图提示有新邮件。使用mail命令查看邮件列表，都是后端服务器状态检测的邮件，说明配置的报警邮件生效了。应为后端服务器还没有配置所以检测的状态全是down。  
  
启动主服务器，地址又漂移回了主服务器  
  
  
  
配置RS服务器  
RS1配置  
[root\@CentOS6.9 \~]\#yum -y install httpd \#安装httpd服务  
[root\@CentOS6.9 \~]\#vim lvs.sh \#创建一个配置脚本

\#!/bin/bash  
vip=192.168.166.100 \#VIP地址  
mask=255.255.255.255  
dev=eth0:1  
case \$1 in  
start)  
echo 1 \> /proc/sys/net/ipv4/conf/all/arp_ignore  
echo 1 \> /proc/sys/net/ipv4/conf/lo/arp_ignore  
echo 2 \> /proc/sys/net/ipv4/conf/all/arp_announce  
echo 2 \> /proc/sys/net/ipv4/conf/lo/arp_announce  
ifconfig \$dev \$vip netmask \$mask broadcast \$vip up  
route add -host \$vip dev \$dev  
;;  
stop)  
ifconfig \$dev down  
echo 0 \> /proc/sys/net/ipv4/conf/all/arp_ignore  
echo 0 \> /proc/sys/net/ipv4/conf/lo/arp_ignore  
echo 0 \> /proc/sys/net/ipv4/conf/all/arp_announce  
echo 0 \> /proc/sys/net/ipv4/conf/lo/arp_announce  
;;  
\*)  
echo "Usage: \$(basename \$0) start\|stop"  
exit 1  
;;  
esac

[root\@CentOS6.9 \~]\#bash lvs.sh start  
[root\@CentOS6.9 \~]\#ip a l eth0:0  
  
[root\@CentOS6.9 \~]\#echo WebServer1 \> /var/www/html/index.html  
[root\@CentOS6.9 \~]\#service httpd start  
  
使用ipvsadm 命令查看lvs配置信息，RS1服务器已经调度器添加进集群。

RS2配置  
[root\@CentOS6.9-1 \~]\#yum -y install httpd  
[root\@CentOS6.9-1 \~]\#vim lvs.sh \#和上面RS1的lvx.sh内容相同  
[root\@CentOS6.9-1 \~]\#echo WebServer2 \> /var/www/html/index.html  
[root\@CentOS6.9-1 \~]\#cat /var/www/html/index.html  
WebServer2  
[root\@CentOS6.9-1 \~]\#service httpd start

第二台RS服务器上线  
  
客户端测试  
因为使用的是轮询算法，所以会在Web1和Web2之间来回调度。  
注意：如果在测试是开启了lvs的长连接，会导致在设置的时间内把客户端一直调度到同一台RS服务器上面。  
  
关闭主调度器  
  
客户端访问  
我们还可以使用这些主机配置来两套LVS高可用，做一个双主模型

第二套LVS信息  
  
VIP：192.168.166.200  
  
第一台调度器为备份服务器  
  
第二台调度器为主服务器

第一台调度器配置

! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1  
smtp_connect_timeout 30  
router_id CentOS7.3  
vrrp_mcast_group4 224.26.1.1  
}  
  
vrrp_instance VI_1 {  
state MASTER  
interface eth0  
virtual_router_id 66  
priority 100  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 123456  
}  
virtual_ipaddress {  
192.168.166.100  
}  
}  
  
virtual_server 192.168.166.100 80 {  
delay_loop 6  
lb_algo rr  
lb_kind DR  
nat_mask 255.255.255.0  
\# persistence_timeout 50  
protocol TCP  
sorry_server 127.0.0.1 80  
real_server 192.168.166.129 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
  
real_server 192.168.166.131 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
}

\# 第二套虚拟路由

vrrp_instance VI_2 {  
state BACKUP  
interface eth0  
virtual_router_id 88 \#ID不要和第一套虚拟路由相同  
priority 90  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 12345678  
}  
virtual_ipaddress {  
192.168.166.200  
}  
}  
  
virtual_server 192.168.166.200 80 {  
delay_loop 6  
lb_algo rr  
lb_kind DR  
nat_mask 255.255.255.0  
\# persistence_timeout 50  
protocol TCP  
sorry_server 127.0.0.1 80  
  
real_server 192.168.166.129 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
  
real_server 192.168.166.131 80 {  
weight 1  
HTTP_GET {  
url {  
path /  
status_code 200  
}  
connect_timeout 1  
nb_get_retry 3  
delay_before_retry 1  
}  
}  
}

第二台的配置这里就不列出了,把第一台服务器的配置文件修改一下。

第一台服务器  
  
第二台服务器  
  
RS配置

\#!/bin/bash  
vip=192.168.166.100  
mask=255.255.255.255  
dev=eth0:1  
vip2=192.168.166.200 \#添加一个VIP2  
mask2=255.255.255.255  
dev2=eth0:2 \#再添加一个eth0：2别名  
case \$1 in  
start)  
echo 1 \> /proc/sys/net/ipv4/conf/all/arp_ignore  
echo 1 \> /proc/sys/net/ipv4/conf/lo/arp_ignore  
echo 2 \> /proc/sys/net/ipv4/conf/all/arp_announce  
echo 2 \> /proc/sys/net/ipv4/conf/lo/arp_announce  
ifconfig \$dev \$vip netmask \$mask broadcast \$vip up  
ifconfig \$dev2 \$vip2 netmask \$mask2 broadcast \$vip2 up \#设置地址  
route add -host \$vip dev \$dev  
route add -host \$vip2 dev \$dev2  
  
;;  
stop)  
ifconfig \$dev down  
ifconfig \$dev2 down  
echo 0 \> /proc/sys/net/ipv4/conf/all/arp_ignore  
echo 0 \> /proc/sys/net/ipv4/conf/lo/arp_ignore  
echo 0 \> /proc/sys/net/ipv4/conf/all/arp_announce  
echo 0 \> /proc/sys/net/ipv4/conf/lo/arp_announce  
;;  
\*)  
echo "Usage: \$(basename \$0) start\|stop"  
exit 1  
;;  
esac

注：上面这份脚本RS1和RS2通用  
  
RS  
  
RS2  
  
调度器LVS规则  
  
测试
