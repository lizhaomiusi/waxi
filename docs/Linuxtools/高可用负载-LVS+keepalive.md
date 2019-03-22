LVS结合keepalive

https://www.toutiao.com/i6622856500794622468/

1.LVS(一)：基本概念和三种模式 https://www.cnblogs.com/f-ck-need-u/p/8451982.html  
2.LVS(二)：VS_TUN和VS_DR的arp问题(精)
https://www.cnblogs.com/f-ck-need-u/p/8455004.html  
3.LVS(三)：ipvsadm命令 https://www.cnblogs.com/f-ck-need-u/p/8527125.html  
4.LVS(四)：详细剖析VS/NAT和VS/DR(精)
https://www.cnblogs.com/f-ck-need-u/p/8472744.html  
5.LVS(五)：加权轮询调度算法规律分析(精)
https://www.cnblogs.com/f-ck-need-u/p/9490629.html  
6.KeepAlived(一)：基本概念和配置文件
https://www.cnblogs.com/f-ck-need-u/p/8483807.html  
7.KeepAlived(二)：keepalived+lvs
https://www.cnblogs.com/f-ck-need-u/p/8492298.html  
8.KeepAlived(三)：vrrp故障转移(+haproxy)
https://www.cnblogs.com/f-ck-need-u/p/8566233.html  
  
LVS可以实现负载均衡，但是不能够进行健康检查，比如一个rs出现故障，LVS
仍然会把请求转发给故障的rs服务器，这样就会导致请求的无效性。keepalive
软件可以进行健康检查，而且能同时实现 LVS 的高可用性，解决 LVS
单点故障的问题，其实 keepalive 就是为 LVS 而生的。  
1、实验环境

4台节点  
Keepalived1 + lvs1(Director1) 10.1.2.12  
Keepalived2 + lvs2(Director2) 10.1.2.13  
Real server1 10.1.2.14  
Real server2 10.1.2.15  
VIP 10.1.2.100  
  
2、安装系统软件  
\#Lvs + keepalived的2个节点安装  
yum install ipvsadm keepalived -y  
\#  
\#Real server + nginx服务的2个节点安装  
yum install epel-release -y  
yum install nginx -y

3、设置配置脚本  
Real server节点2台配置脚本：  
\#!/bin/bash  
VIP1=10.1.2.100  
RS=\`ifconfig \|sed -n '2p' \|awk -F'[: ]+' '{print \$4}'\`  
echo "\$RS" \>/usr/share/nginx/html/index.html  
ifconfig lo:0 \$VIP1 broadcast \$VIP1 netmask 255.255.255.255 up  
route add -host \$VIP1 lo:0  
echo "1" \>/proc/sys/net/ipv4/conf/lo/arp_ignore  
echo "2" \>/proc/sys/net/ipv4/conf/lo/arp_announce  
echo "1" \>/proc/sys/net/ipv4/conf/all/arp_ignore  
echo "2" \>/proc/sys/net/ipv4/conf/all/arp_announce  
  
keepalived节点配置(2节点)：  
\#主节点( MASTER )配置文件  
vi /etc/keepalived/keepalived.conf

! Configuration File for keepalived  
  
global_defs {  
\# 通知邮件服务器的配置  
notification_email {  
\# 当master失去VIP或则VIP的时候，会发一封通知邮件到your-email\@qq.com  
your-email\@qq.com  
}  
\# 发件人信息  
notification_email_from keepalived\@qq.com  
\# 邮件服务器地址  
smtp_server 127.0.0.1  
\# 邮件服务器超时时间  
smtp_connect_timeout 30  
\# 邮件TITLE  
router_id LVS_DEVEL  
}  
  
vrrp_instance VI_1 {  
\# 主机: MASTER  
\# 备机: BACKUP  
state MASTER  
\# 实例绑定的网卡, 用ip a命令查看网卡编号  
interface eno16777984  
\# 虚拟路由标识，这个标识是一个数字(1-255)，在一个VRRP实例中主备服务器ID必须一样  
virtual_router_id 88  
\# 优先级，数字越大优先级越高，在一个实例中主服务器优先级要高于备服务器  
priority 100  
\# 主备之间同步检查的时间间隔单位秒  
advert_int 1  
\# 验证类型和密码  
authentication {  
\# 验证类型有两种 PASS和HA  
auth_type PASS  
\# 验证密码，在一个实例中主备密码保持一样  
auth_pass 11111111  
}  
\# 虚拟IP地址,可以有多个，每行一个  
virtual_ipaddress {  
192.168.1.100  
}  
}  
  
virtual_server 192.168.1.100 443 {  
\# 健康检查时间间隔  
delay_loop 6  
\# 调度算法  
\# Doc: http://www.keepalived.org/doc/scheduling_algorithms.html  
\# Round Robin (rr)  
\# Weighted Round Robin (wrr)  
\# Least Connection (lc)  
\# Weighted Least Connection (wlc)  
\# Locality-Based Least Connection (lblc)  
\# Locality-Based Least Connection with Replication (lblcr)  
\# Destination Hashing (dh)  
\# Source Hashing (sh)  
\# Shortest Expected Delay (seq)  
\# Never Queue (nq)  
\# Overflow-Connection (ovf)  
lb_algo rr  
lb_kind NAT  
persistence_timeout 50  
protocol TCP  
\# 通过调度算法把Master切换到真实的负载均衡服务器上  
\# 真实的主机会定期确定进行健康检查，如果MASTER不可用，则切换到备机上  
real_server 192.168.1.101 443 {  
weight 1  
TCP_CHECK {  
\# 连接超端口  
connect_port 443  
\# 连接超时时间  
connect_timeout 3  
}  
}  
real_server 192.168.1.102 443 {  
weight 1  
TCP_CHECK {  
connect_port 443  
connect_timeout 3  
}  
}  
}

\# 从节点（BACKUP）配置  
拷贝主节点的配置文件keepalived.conf，然后修改如下内容：  
vi /etc/keepalived/keepalived.conf  
state MASTER -\> state BACKUP  
priority 100 -\> priority 90

vrrp_instance VI_1 {  
state BACKUP  
interface eth0  
virtual_router_id 51  
priority 90  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 1111  
}  
virtual_ipaddress {  
10.1.2.100  
}  
}  
  
virtual_server 10.1.2.100 80 {  
delay_loop 6  
lb_algo rr  
lb_kind DR  
persistence_timeout 0  
protocol TCP  
  
real_server 10.1.2.14 80 {  
weight 1  
TCP_CHECK {  
connect_timeout 10  
nb_get_retry 3  
delay_before_retry 3  
connect_port 80  
}  
}  
  
real_server 10.1.2.15 80 {  
weight 1  
TCP_CHECK {  
connect_timeout 10  
nb_get_retry 3  
delay_before_retry 3  
connect_port 80  
}  
}  
}  
  
\#keepalived的2个节点执行如下命令，开启转发功能：  
echo 1 \> /proc/sys/net/ipv4/ip_forward  
  
\#启动keepalive  
\#先主后从分别启动keepalive  
service keepalived start  
  
验证成功  
抢占模式  
  
PS： 配置非抢占模式 两台配置两个地方不同 其他都是相同的  
vrrp_instance VI_1 {  
state BACKUP \# 不抢占模式 两台都为BACKUP  
interface eth0  
virtual_router_id 51  
priority 100  
nopreempt \# 主新增nopreempt
