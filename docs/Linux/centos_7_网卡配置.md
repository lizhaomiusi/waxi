安装完centos 7 配置  
  
CentOS7网络配置  
nmtui  
或者  
vim /etc/sysconfig/network-scripts/ifcfg-enp0s9  
HWADDR=08:00:27:7D:65:85  
TYPE=Ethernet  
PROXY_METHOD=none  
BROWSER_ONLY=no  
BOOTPROTO=none \#启用静态IP地址  
DEFROUTE=yes  
IPV4_FAILURE_FATAL=no  
IPV6INIT=yes  
IPV6_AUTOCONF=yes  
IPV6_DEFROUTE=yes  
IPV6_FAILURE_FATAL=no  
IPV6_ADDR_GEN_MODE=stable-privacy  
NAME=enp0s9  
UUID=14cdefe7-969d-3cdd-a50b-066a44775d1a  
ONBOOT=yes \#自启  
IPADDR=192.168.0.10 \#IP地址  
PREFIX=24 \#子网掩码  
GATEWAY=192.168.0.1 \#网关  
DNS1=223.5.5.5 \#dns1  
AUTOCONNECT_PRIORITY=-999  
\#重启网络  
systemctl restart network  
  
CentOS7中已经取消了ifconfig，用nmcli进行了代替，服务管理也升级为systemd。  
  
eno1 ：代表由主板 BIOS 內建的网卡  
ens1 ：代表由主板 BIOS 內建的 PCI-E 界面的网卡  
enp2s0 ：代表 PCI-E 界面的独立网卡，可能有多个网卡接口，因此会有 s0, s1...
的编号  
eth0 ：如果上述的名称都不适用，就回到原本的预设网卡编号  
  
3、查看配置后的网卡配置信息  
[root\@localhost \~]\# nmcli connection show enp0s3  
connection.id: enp0s3  
connection.uuid: 5d58d8cc-8caf-458b-a672-ed0cdf58292e  
......(中间省略)......  
ipv4.method: manual  
ipv4.dns: 202.96.69.38  
ipv4.dns-search:  
ipv4.addresses: 172.20.31.221/24  
ipv4.gateway: 172.20.31.240  
......(中间省略)......  
IP4.地址[1]: 172.20.31.221/24  
IP4.网关: 172.20.31.240  
IP4.DNS[1]: 202.96.69.38  
......(以下省略)......  
因为在CentOS7.x中取消了ifconfig命令， 我们使用ip addr来代替。  
[root\@localhost \~]\# ip addr  
1: lo: \<LOOPBACK,UP,LOWER_UP\> mtu 65536 qdisc noqueue state UNKNOWN  
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
inet 127.0.0.1/8 scope host lo  
valid_lft forever preferred_lft forever  
inet6 ::1/128 scope host  
valid_lft forever preferred_lft forever  
2: enp0s3: \<BROADCAST,MULTICAST,UP,LOWER_UP\> mtu 1500 qdisc pfifo_fast state
UP qlen 1000  
link/ether 08:00:27:ef:69:36 brd ff:ff:ff:ff:ff:ff  
inet 172.20.31.221/24 brd 172.20.31.255 scope global enp0s3  
valid_lft forever preferred_lft forever  
inet6 fe80::a00:27ff:feef:6936/64 scope link  
valid_lft forever preferred_lft forever
