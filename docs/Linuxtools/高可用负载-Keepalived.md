Linux高可用之Keepalived

https://www.jianshu.com/p/b050d8861fc1  
  
Keepalived是基于vrrp协议的一款高可用软件。Keepailived有一台主服务器和多台备份服务器，在主服务器和备份服务器上面部署相同的服务配置，使用一个虚拟IP地址对外提供服务，当主服务器出现故障时，虚拟IP地址会自动漂移到备份服务器。  
  
VRRP（Virtual Router Redundancy
Protocol，虚拟路由器冗余协议），VRRP是为了解决静态路由的高可用。VRRP的基本架构  
虚拟路由器由多个路由器组成，每个路由器都有各自的IP和共同的VRID(0-255)，其中一个VRRP路由器通过竞选成为MASTER，占有VIP，对外提供路由服务，其他成为BACKUP，MASTER以IP组播（组播地址：224.0.0.18）形式发送VRRP协议包，与BACKUP保持心跳连接，若MASTER不可用（或BACKUP接收不到VRRP协议包），则BACKUP通过竞选产生新的MASTER并继续对外提供路由服务，从而实现高可用。  
  
keepalived主要有三个模块，分别是  
core
core模块为keepalived的核心，负责主进程的启动、维护以及全局配置文件的加载和解析。  
check check负责健康检查，IPVS集群的RS做健康检查。  
vrrp vrrp模块是来实现VRRP协议的。  
  
vrrp协议的相关术语：  
虚拟路由器：Virtual Router  
虚拟路由器标识：VRID(0-255)  
物理路由器：  
master ：主设备  
backup ：备用设备  
priority：优先级  
VIP：Virtual IP  
VMAC：Virutal MAC (00-00-5e-00-01-VRID)  
GraciousARP  
  
安全认证：  
简单字符认证、HMAC机制，只对信息做认证  
MD5（leepalived不支持）  
  
工作模式：  
主/备：单虚拟路径器；  
主/主：主/备（虚拟路径器），备/主（虚拟路径器）  
  
工作类型:  
抢占式：当出现比现有主服务器优先级高的服务器时，会发送通告抢占角色成为主服务器  
非抢占式：  
  
注意：  
各节点时间必须同步  
确保各节点的用于集群服务的接口支持MULTICAST通信（组播）；  
  
  
安装  
从CentOS 6.4开始keepalived随系统base仓库提供，可以使用  
yun -y install keepalived  
  
配置文件：  
主配置文件：/etc/keepalived/keepalived.conf  
主程序文件：/usr/sbin/keepalived  
提供校验码：/usr/bin/genhash  
Unit File：keepalived.service  
Unit File的环境配置文件：/etc/sysconfig/keepalived  
  
主配置文件详解  
https://www.cnblogs.com/along1226/p/5027838.html

! Configuration File for keepalived  
  
global_defs {  
notification_email { \#发送报警邮件收件地址  
acassen\@firewall.loc  
failover\@firewall.loc  
sysadmin\@firewall.loc  
}  
notification_email_from Alexandre.Cassen\@firewall.loc \#指明报警邮件的发送地址  
smtp_server 192.168.200.1 \#邮件服务器地址  
smtp_connect_timeout 30 \#smtp的超时时间  
router_id LVS_DEVEL \#物理服务器的主机名  
vrrp_mcast_group4 \#定义一个组播地址  
static_ipaddress  
{  
192.168.1.1/24 dev eth0 scope global  
}  
static_routes  
{  
192.168.2.0/24 via 192.168.1.100 dev eth0  
}  
  
}  
vrrp_sync_group VG_1 { \#
定义一个故障组，组内有一个虚拟路由出现故障另一个也会一起跟着转移，适用于LVS的NAT模型。  
group {  
VI1 \# name of vrrp_instance (below)  
VI2 \# One for each moveable IP  
  
}  
}  
  
vrrp_instance VI_1 { \# 定义一个虚拟路由  
state MASTER\|BACKUP \#
当前节点在此虚拟路由器上的初始状态；只能有一个是MASTER，余下的都应该为BACKUP；  
interface eth0 \# 绑定为当前虚拟路由器使用的物理接口；  
virtual_router_id 51 \# 当前虚拟路由器的惟一标识，范围是0-255；  
priority 100 \# 当前主机在此虚拟路径器中的优先级；范围1-254；  
advert_int 1 \# 通告发送间隔，包含主机优先级、心跳等。  
authentication { \# 认证配置  
auth_type PASS \# 认证类型，PASS表示简单字符串认证  
auth_pass 1111 \# 密码,PASS密码最长为8位  
  
virtual_ipaddress {  
192.168.200.16 \# 虚拟路由IP地址，以辅助地址方式设置  
192.168.200.18/24 dev eth2 label eth2:1 \#以别名的方式设置  
}  
  
track_interface {  
eth0  
eth1  
  
} \#配置要监控的网络接口，一旦接口出现故障，则转为FAULT状态；  
nopreempt \#定义工作模式为非抢占模式；  
preempt_delay 300 \#抢占式模式下，节点上线后触发新选举操作的延迟时长；  
virtual_routes { \#配置路由信息，可选项  
\# src \<IPADDR\> [to] \<IPADDR\>/\<MASK\> via\|gw \<IPADDR\> [or \<IPADDR\>]
dev \<STRING\> scope  
\<SCOPE\> tab  
src 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1  
192.168.112.0/24 via 192.168.100.254 192.168.113.0/24 via 192.168.200.254 or
192.168.100.254 dev eth1 blackhole 192.168.114.0/24  
}  
  
notify_master \<STRING\>\|\<QUOTED-STRING\> \#当前节点成为主节点时触发的脚本。  
notify_backup \<STRING\>\|\<QUOTED-STRING\> \#当前节点转为备节点时触发的脚本。  
notify_fault \<STRING\>\|\<QUOTED-STRING\>
\#当前节点转为“失败”状态时触发的脚本。  
notify \<STRING\>\|\<QUOTED-STRING\>
\#通用格式的通知触发机制，一个脚本可完成以上三种状态的转换时的通知。  
smtp_alert \#如果加入这个选项，将调用前面设置的邮件设置，并自动根据状态发送信息  
}  
virtual_server 192.168.200.100 443 { \#LVS配置段 ，设置LVS的VIP地址和端口  
delay_loop \#服务轮询的时间间隔；检测RS服务器的状态。  
lb_algo rr \#调度算法，可选rr\|wrr\|lc\|wlc\|lblc\|sh\|dh。  
lb_kind NAT \#集群类型，可选NAT\|DR\|TUN。  
nat_mask 255.255.255.0 \#子网掩码，可选项。  
persistence_timeout 50 \#是否启用持久连接，连接保存时长  
protocol TCP \#协议，只支持TCP  
sorry_server \<IPADDR\> \<PORT\> \#备用服务器地址，可选项。  
  
real_server 192.168.201.100 443 { \#配置RS服务器的地址和端口  
weight 1 \#权重  
SSL_GET { \#检测RS服务器的状态，发送请求报文  
url {  
path / \#请求的URL  
digest ff20ad2481f97b1754ef3e12ecd3a9cc
\#对请求的页面进行hash运算，然后和这个hash码进行比对，如果hash码一样就表示状态正常  
status_code \<INT\> \#判断上述检测机制为健康状态的响应码,和digest二选一即可。  
  
} \#这个hash码可以使用genhash命令请求这个页面生成  
connect_timeout 3 \#连接超时时间  
nb_get_retry 3 \#超时重试次数  
delay_before_retry 3 \#每次超时过后多久再进行连接  
connect_ip \<IP ADDRESS\> \#向当前RS的哪个IP地址发起健康状态检测请求  
connect_port \<PORT\> \#向当前RS的哪个PORT发起健康状态检测请求  
bindto \<IP ADDRESS\> \#发出健康状态检测请求时使用的源地址；  
bind_port \<PORT\> \#发出健康状态检测请求时使用的源端口；  
}  
}  
}  
  
健康状态检测机制  
HTTP_GET  
SSL_GET  
TCP_CHECK  
SMTP_CHECK  
MISS_CHECK \#调用自定义脚本进行检测  
---  
TCP_CHECK {  
connect_ip \<IP ADDRESS\> \#向当前RS的哪个IP地址发起健康状态检测请求;  
connect_port \<PORT\> \#向当前RS的哪个PORT发起健康状态检测请求;  
bindto \<IP ADDRESS\> \#发出健康状态检测请求时使用的源地址；  
bind_port \<PORT\> \#发出健康状态检测请求时使用的源端口；  
connect_timeout \<INTEGER\> \#连接请求的超时时长；  
}
