虚拟机下复制镜像导致网卡不识别

解决方法

1.vim /etc/udev/rules.d/70-persistent-net.rules  
找到与ifconfig -a得出的MAC相同的一行（NAME='eth1'这一行），把它改为"NAME=eth0
"，然后把上面一行（NAME='eth0'）删除掉。  
或者清空  
\> /etc/udev/rules.d/70-persistent-net.rules  
echo "\> /etc/udev/rules.d/70-persistent-net.rules" \>\> /etc/rc.local \#
放入开启启动防止双网卡

2.编辑/etc/sysconfig/network-script/ifcfg-eth0,把MAC改为正确的，把UUID删掉。

3.编辑/etc/sysconf/network，把hostname也改一下。

4.重启生效！  
  
linux 网卡配置文件详解  
临时生效  
ifconfig eth0:0 10.0.2.10/24 up\|\|(down)  
ip addr add\|\|(del) 10.0.2.1/24 dev eth0:0  
  
永久生效  
ifconfig eth0 192.168.21.11 netmask 255.255.255.255 up（down）  
配置文件位置：vi /etc/sysconfig/network-scripts/ifcfg-eth0  
DEVICE=eth0 \#网卡  
TYPE=Etherne \# 网卡类型以太网  
UUID=5ce935cf-2271-45fb-af4d-bcc8b9a0b724  
ONBOOT=yes \# 自启动  
NM_CONTROLLED=yes \# 是否受network管理  
BOOTPROTO=none \# dhcp none禁用dhcp static固定  
HWADDR=08:00:27:d4:34:61 \# mac地址  
DEFROUTE=yes \# 是否设置为默认路由  
PEERROUTES=yes  
IPV4_FAILURE_FATAL=yes  
IPV6INIT=no  
NAME="System eth0" \# 网卡名  
IPADDR=192.168.0.22  
NETMASK=255.255.255.0  
DNS2=223.5.5.6  
GATEWAY=192.168.0.254  
DNS1=223.5.5.5  
USERCTL=no \# 普通用户能否控制网卡  
  
重启网卡 /etc/init.d/network restart  
  
多网卡的案例  
cat /etc/udev/rules.d/70-persistent-net.rules 可以查看已经有两块网卡了  
但是在/etc/sysconfig/network-script/下还看不到eth1的文件；  
到/etc/sysconfig/network-script/下复制eth0文件  
cp ifcfg-eht0 ifcfg-eht1  
然后修改mac地址(根据virtualbox里面生成的地址)、uuid、网卡名字等信息
