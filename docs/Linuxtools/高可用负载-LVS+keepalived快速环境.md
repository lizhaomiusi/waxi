高可用负载-LVS+keepalived快速环境

centos6

\# LVS 负载均衡模式：DR（直接路由）

192.168.18.31 master(LVS)

192.168.18.32 slave(LVS)

192.168.18.18 VIP

192.168.18.11 web1

192.168.18.12 web2

\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

\#手动配置测试

\#\#\#LVS 安装配置

yum install ipvsadm -y

rpm -ql ipvsadm

\# ipvsadm

\# lsmod\|grep ip_vs

\#添加VIP

/sbin/ifconfig eth1:1 192.168.18.18/24 up

\#ifconfig eth1:1 down \#测试完后停止VIP

ipvsadm -C \#清空

\#添加虚拟服务

ipvsadm -A -t 192.168.18.18:80 -s wrr -p 20

\#添加后端服务

ipvsadm -a -t 192.168.18.18:80 -r 192.168.18.11:80 -g -w 1

ipvsadm -a -t 192.168.18.18:80 -r 192.168.18.12:80 -g -w 1

\#删除ipvsadm -d -t 192.168.18.18:80 -r 192.168.18.11:80

ipvsadm -L -n \#查看列表

\#\#\#\#\#\#\#\#\#\#

\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

\# 后端WEB配置

\# 安装Apache或nginx，启动服务

\# yum install httpd -y

\# echo “this is rs1” \> /var/www/html/index.html

\# service httpd restart

vim lvs-rs.sh

\#!/bin/bash

\# 配置VIP、配置ARP抑制

VIP=192.168.18.18

. /etc/rc.d/init.d/functions

case "\$1" in

start)

echo " start LVS of REALServer"

/sbin/ifconfig lo:0 \$VIP broadcast \$VIP netmask 255.255.255.255 up

/sbin/route add -host \$VIP dev lo:0

echo "1" \>/proc/sys/net/ipv4/conf/lo/arp_ignore

echo "2" \>/proc/sys/net/ipv4/conf/lo/arp_announce

echo "1" \>/proc/sys/net/ipv4/conf/all/arp_ignore

echo "2" \>/proc/sys/net/ipv4/conf/all/arp_announce

sysctl -p \>/dev/null 2\>&1

;;

stop)

/sbin/ifconfig lo:0 down

echo "close LVS Directorserver"

echo "0" \>/proc/sys/net/ipv4/conf/lo/arp_ignore

echo "0" \>/proc/sys/net/ipv4/conf/lo/arp_announce

echo "0" \>/proc/sys/net/ipv4/conf/all/arp_ignore

echo "0" \>/proc/sys/net/ipv4/conf/all/arp_announce

;;

\*)

echo "Usage: \$0 {start\|stop}"

exit 1

esac

exit 0

\#给脚本加权限，并执行

chmod +x lvs-rs.sh

chmod 755 /etc/rc.d/init.d/functions

./lvs-rs.sh start

\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

\#LVS+keepalived 配置

yum install keepalived -y

\#rpm -ql keepalived

\#分别安装配置keepalived

cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak

vim /etc/keepalived/keepalived.conf

/etc/init.d/keepalived restart

/etc/init.d/keepalived stop \#关闭、开启LVS_MASTER测试

ip add \#查看VIP

\#配置如下：

\#\#\#\#\#keepalived配置

! Configuration File forkeepalived

global_defs {

\# notification_email {

\# test\@sina.com \#故障接受联系人

\# }

\# notification_email_from admin\@test.com \#故障发送人

\# smtp_server 127.0.0.1 \#本机发送邮件

\# smtp_connect_timeout 30

router_id LVS_MASTER

\#router_id LVS_BACKUP \#LVS_BACKUP

}

vrrp_instance VI_1 {

state MASTER

\#state BACKUP

interface eth1

virtual_router_id 18 \#虚拟路由标识，主从相同

priority 100

\#priority 90 \#BACKUP

advert_int 1

authentication {

auth_type PASS

auth_pass 1111 \#主从认证密码必须一致

}

virtual_ipaddress { \#Web虚拟IP（VTP）

192.168.18.18/24

}

}

\#\#\#real_server\#\#\#

virtual_server 192.168.18.18 80 { \#定义虚拟IP和端口

delay_loop 6 \#检查真实服务器时间，单位秒

lb_algo rr \#设置负载调度算法，rr为轮训

lb_kind DR \#设置LVS负载均衡DR模式

persistence_timeout 30 \#同一IP的连接30秒内被分配到同一台真实服务器

protocol TCP \#使用TCP协议检查realserver状态

real_server 192.168.18.11 80 { \#第一个web服务器

weight 3 \#节点权重值

TCP_CHECK { \#健康检查方式

connect_timeout 3 \#连接超时

nb_get_retry 3 \#重试次数

delay_before_retry 3 \#重试间隔/S

}

}

real_server 192.168.18.12 80 { \#第二个web服务器

weight 3

TCP_CHECK {

connect_timeout 3

nb_get_retry 3

delay_before_retry 3

}

}

}

\#\#\#\#\#keepalived配置

\#\#

curl http://192.168.18.18 \>/tmp/null \#http访问测试

tail -10 /var/log/nginx/access.log \#查看nginx日志

tail -10 /etc/httpd/logs/access_log \#查看Apache日志
