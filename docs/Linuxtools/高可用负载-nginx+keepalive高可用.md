高可用负载-nginx+keepalive高可用

http://www.keepalived.org/manpage.html

http://www.linuxe.cn/post-266.html

https://blog.csdn.net/death_kada/article/details/49635729

实验环境：

系统版本：Centos-7.2

VIP

192.168.0.66

主机IP

192.168.1.100

192.168.1.110

1、配置本地yum源，方便安装依赖包

2、安装nginx依赖包

yum -y install gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib
zlib-devel openssl openssl-devel

3、nginx官网下载源包或者epel

http://nginx.org/download/nginx-1.15.9.tar.gz

yum install epel-release -y

yum install nginx -y

4、安装nginx

在两台机器上都安装，执行如下命令

mv nginx-1.15.9.tar.gz /usr/local/src/

tar -zxvf nginx-1.15.9.tar.gz

cd nginx-1.15.9

./configure -prefix=/usr/loal/nginx

5、配置nginx

echo "\$IP" \> /usr/local/nginx/html/index.html

6、下载安装keepalived

yum install keepalived -y

安装过程：

wget http://www.keepalived.org/software/keepalived-2.0.13.tar.gz

mv keepalived-2.0.13.tar.gz /usr/local/src/

tar -zxvf keepalived-2.0.13.tar.gz

cd keepalived-2.0.13

./configure -prefix=/usr/local/keepalived

make && make install

7、配置keepalived

vrrp_script check_nginx \# 检查nginx状态脚本

{ \# 这个“{”要换行写，不然脚本不生效（踩过的坑）

script "/scripts/check_nginx.sh" \# 脚本位置

interval 5 \# 执行脚本时间间隔，单位秒

}

vrrp_instance VI_1 { \# 实例名

state MASTER \# 标记该节点是主节点还是备节点

interface eth1 \# 配置VIP绑定的网卡

virtual_router_id 66 \# 取1-255之间的数值，主备需要相同

priority 100 \# 权重，数值高的是Master，这是主备的关键参数

advert_int 1 \# 主备之间通信的间隔

authentication {

auth_type PASS \# 主备之间进行安全验证的方式，主备需一致

auth_pass 6666

}

virtual_ipaddress { \# VIP，可以写多个

192.168.1.66

}

track_script { \# 调用脚本

check_nginx

}

}

脚本

vi /scripts/check_nginx.sh

\#!/bin/bash

A=\`ps -C nginx --no-headers \| wc -l\`

if [ \$A -eq 0 ];then

/usr/local/nginx/sbin/nginx

sleep 5

B=\`ps -C nginx --no-headers \| wc -l\`

if [ \$B -eq 0 ];then

killall keepalived

fi

fi
