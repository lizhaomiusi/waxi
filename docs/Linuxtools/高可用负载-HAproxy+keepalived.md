利用keepalived和haproxy配置mysql的高可用负载均衡

HAproxy配置  
https://www.cnblogs.com/tae44/p/4717334.html  
https://www.jianshu.com/p/01eb60ed7d8c  
https://www.jianshu.com/p/495d4a8812e7

准备5台CentOS7.3主机和一个VIP地址:  
yum install haproxy -y  
or  
下载并解压  
需要翻墙

http://www.haproxy.org/download/1.7/src/haproxy-1.7.2.tar.gz  
tar -xzf haproxy-1.7.2.tar.gz  
  
下面案例通过yum安装  
准备一个可用IP用作虚拟IP(VIP):  
VIP=10.1.2.100  
负载均衡器会用到2台主机，一主一备的架构  
lb1(默认为主)=10.1.2.12  
lb2(默认为备)=10.1.2.13  
后端服务器集群中主机的IP地址  
S1=10.1.2.14  
S2=10.1.2.15  
S3=10.1.2.16  
  
所有主机上关闭防火墙  
systemctl stop firewalld  
systemctl disable firewalld  
所有主机关闭selinux  
setenforce 0  
vi /etc/selinux/config  
SELINUX=disabled  
  
安装haproxy和keepalived  
lb1和lb2上安装haproxy和keepalived  
yum install haproxy keepalived -y  
  
s1 s2 s3上安装nginx，目的是把nginx作为后端，如果有其他后端程序，这一步可以省略  
yum install epel-release -y  
yum install nginx -y  
  
配置主keepalived  
编辑lb1  
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
  
  
配置从keepalived  
编辑lb2  
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
state BACKUP  
\# 实例绑定的网卡, 用ip a命令查看网卡编号  
interface eno16777984  
\# 虚拟路由标识，这个标识是一个数字(1-255)，在一个VRRP实例中主备服务器ID必须一样  
virtual_router_id 88  
\# 优先级，数字越大优先级越高，在一个实例中主服务器优先级要高于备服务器  
priority 99  
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

配置haproxy  
编辑lb1和lb2上的  
/etc/haproxy/haproxy.cfg  
把后端服务器包含IP加到backend里  
  
配置haproxy服务:  
注释掉默认的代理配置并添加如下的一个简单的配置；  
vim /etc/haproxy/haproxy.cfg  
  
frontend testweb \#定义名称为 testweb 的frontend  
bind \*:80 \#监听所有地址的web服务80端口  
default_backend mywebs \#定义名称为mywebs的backend后端web服务  
  
backend mywebs \#定义名称为mywebs的backend  
balance roundrobin \#定义负载均衡算法  
server srv1 192.168.21.11:80 check  
server srv2 192.168.21.12:80 check  
server srv2 192.168.21.13:80 check

配置nginx  
  
echo "10.1.2.14" /usr/share/nginx/html/index.html  
echo "10.1.2.15" /usr/share/nginx/html/index.html  
  
重启服务nginx haproxy keepalived  
  
systemctl restart nginx  
systemctl enable nginx  
systemctl restart haproxy  
systemctl enable haproxy  
systemctl restart keepalived  
systemctl enable keepalived  
  
在MASTER上运行ip a  
会发现VIP(10.1.2.100)已经绑定好了如果发现VIP无法绑定  
vi /etc/sysctl.conf  
添加两行  
net.ipv4.ip_forward = 1  
net.ipv4.ip_nonlocal_bind = 1  
让新配置生效  
sysctl -p  
  
验证和测试  
  
1. 在浏览器输入 http://10.1.2.100 https://10.1.2.100
查看是否成功显示nginx欢迎页面  
2. lb1关机，查看是否还可以访问http://10.1.2.100，
如果成功，则说明VIP成功切换到备机  
3. lb2上执行ip a，查看网卡是否绑定VIP(192.168.21.100)
