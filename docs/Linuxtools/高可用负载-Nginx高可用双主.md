高可用负载-Nginx高可用双主

高可用双主Nginx  
  
配置Nginx主机  
  
[root\@centos7.3 \~]\#yum -y install nginx

[root\@centos7.3 \~]\#vim /etc/nginx/nginx.conf

user nginx;  
worker_processes auto;  
error_log /var/log/nginx/error.log;  
pid /run/nginx.pid;  
  
\# Load dynamic modules. See /usr/share/nginx/README.dynamic.  
include /usr/share/nginx/modules/\*.conf;  
  
events {  
worker_connections 1024;  
}  
  
http {  
log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '  
'\$status \$body_bytes_sent "\$http_referer" '  
'"\$http_user_agent" "\$http_x_forwarded_for"';  
  
access_log /var/log/nginx/access.log main;  
  
sendfile on;  
tcp_nopush on;  
tcp_nodelay on;  
keepalive_timeout 65;  
types_hash_max_size 2048;  
  
include /etc/nginx/mime.types;  
default_type application/octet-stream;  
  
upstream web { \# 在http上下文中添加一个服务器组，web是组名。  
server 192.168.166.129:80; \# 后端服务器的地址和端口  
server 192.168.166.132:80;  
}  
  
\# Load modular configuration files from the /etc/nginx/conf.d directory.  
\# See http://nginx.org/en/docs/ngx_core_module.html\#include  
\# for more information.  
include /etc/nginx/conf.d/\*.conf;  
  
server {  
listen [::]:80 default_server;  
server_name \_;  
root /usr/share/nginx/html;  
  
\# Load configuration files for the default server block.  
include /etc/nginx/default.d/\*.conf;  
  
location / {  
}  
  
error_page 404 /404.html;  
location = /40x.html {  
}  
include /etc/nginx/conf.d/\*.conf;  
  
server {  
listen [::]:80 default_server;  
server_name \_;  
root /usr/share/nginx/html;  
  
\# Load configuration files for the default server block.  
include /etc/nginx/default.d/\*.conf;  
  
location / {  
}  
  
error_page 404 /404.html;  
location = /40x.html {  
}  
  
error_page 500 502 503 504 /50x.html;  
location = /50x.html {  
}  
}

定义两个Nginx虚拟主机  
  
[root\@centos7.3 nginx]\#vim /etc/nginx/conf.d/host.conf  
server {  
server_name www.test.com;  
listen 80;  
index index.html;  
root /app/web;  
location / {  
proxy_pass http://web;  
  
}  
}  
  
  
zhu注：以上内容两台主机相同  
  
配置keepalived  
第一台

! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1  
smtp_connect_timeout 30  
router_id CentOS7.3  
vrrp_mcast_group4 224.24.1.1  
}  
  
vrrp_instance VI_1 {  
state MASTER  
interface eth0  
virtual_router_id 66  
priority 100  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 111111  
}  
virtual_ipaddress {  
192.168.166.100/24 dev eth0  
}  
}  
vrrp_instance VI_2 {  
state BACKUP  
interface eth0  
virtual_router_id 88  
priority 90  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 11111111  
}  
virtual_ipaddress {  
192.168.166.200/24 dev eth0  
}  
}

第二台Nginx

! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1  
smtp_connect_timeout 30  
router_id CentOS7.3  
vrrp_mcast_group4 224.24.1.1  
}  
  
vrrp_instance VI_1 {  
state BACKUP  
interface eth0  
virtual_router_id 66  
priority 90  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 111111  
}  
virtual_ipaddress {  
192.168.166.100/24 dev eth0  
}  
}  
vrrp_instance VI_2 {  
state MASTER  
interface eth0  
virtual_router_id 88  
priority 100  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 11111111  
}  
virtual_ipaddress {  
192.168.166.200/24 dev eth0  
}  
}  
  
  
! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1  
smtp_connect_timeout 30  
router_id CentOS7.3-1  
vrrp_mcast_group4 224.24.1.1  
}  
  
vrrp_instance VI_1 {  
state BACKUP  
interface eth0  
virtual_router_id 66  
priority 90  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 111111  
}  
virtual_ipaddress {  
192.168.166.100/24 dev eth0  
}

测试  
  
keepalived可以调用外部的辅助脚本进行资源监控，并根据监控的结果状态能实现优先动态调整；  
  
先定义一个脚本  
vrrp_script \<SCRIPT_NAME\> { \#定义脚本  
script "killall -0 sshd"
\#可以在引号内调用命令或者脚本路径，如果脚本执行成功则不变，如果失败则执行下面的命令  
interval INT \#检测间隔时间  
weight -INT \#减掉权重  
fall 2 \#检测几次判定为失败  
rise 2 \#检测几次判定为成功  
}  
killall -0 只是测试，并不执行操作，用来测试进程是否运行正常  
调用此脚本  
  
track_script {  
SCRIPT_NAME_1 \#调用脚本  
SCRIPT_NAME_2 weight -2 \#如果脚本健康状态检测失败优先级减2  
}  
配置文件

! Configuration File for keepalived  
  
global_defs {  
notification_email {  
root\@localhost  
}  
notification_email_from keepalived\@localhost  
smtp_server 127.0.0.1  
smtp_connect_timeout 30  
router_id CentOS7.3  
vrrp_mcast_group4 224.24.1.1  
}  
vrrp_script nginx {  
script "killall -0 nginx && exit 0 \|\| exit 1"  
interval 1  
weight -15  
fall 2  
rise 1  
}  
vrrp_instance VI_1 {  
state MASTER  
interface eth0  
virtual_router_id 66  
priority 100  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 111111  
}  
virtual_ipaddress {  
192.168.166.100/24 dev eth0  
}  
track_script {  
nginx  
}  
}  
  
vrrp_instance VI_2 {  
state BACKUP  
interface eth0  
virtual_router_id 88  
priority 90  
advert_int 1  
authentication {  
auth_type PASS  
auth_pass 11111111  
}  
virtual_ipaddress {  
192.168.166.200/24 dev eth0  
}  
}

测试  
  
PS:  
不抢占模式 两台配置两个地方不同 其他都是相同的  
vrrp_instance VI_1 {  
state BACKUP \# 不抢占模式 两台都为BACKUP  
interface ens33  
virtual_router_id 51  
priority 100  
nopreempt \# 主新增nopreempt
