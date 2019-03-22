最小化安装完CentOS7你需要知道的事情

1、ifconfig  
在Centos7以后，输入ifconfig会出现下列问题：  
[root\@test \~]\# ifconfig  
-bash: ifconfig: command not found  
[root\@test \~]\#  
解决办法：  
[root\@test \~]\# yum search ifconfig  
Failed to set locale, defaulting to C  
Loaded plugins: fastestmirror  
Loading mirror speeds from cached hostfile  
\* base: mirrors.aliyun.com  
\* extras: mirrors.aliyun.com  
\* updates: mirrors.aliyun.com  
================================================================== Matched:
ifconfig ==================================================================  
net-tools.x86_64 : Basic networking tools  
可以查看到ifconfig在net-tools这个包组下，可以用yum进行安装  
[root\@test \~]\# yum install net-tools -y

2、iptables 防火墙  
CentOS 7.0后默认使用的是firewall作为防火墙，可以改为iptables防火墙。  
首先：先关闭firewalld  
systemctl stop firewalld.service \#停止firewall  
systemctl disable firewalld.service \#禁止firewall开机启动  
然后：安装iptables防火墙  
yum install iptables-services -y \#安装  
vi /etc/sysconfig/iptables \#编辑防火墙配置文件进行配置  
systemctl restart iptables.service \#最后重启防火墙使配置生效  
systemctl stop iptables.service \#设置防火墙开机启动  
systemctl enable iptables.service \#设置防火墙开机启动

3、网卡名称  
CentOS7.0后，很多小伙伴会看到网卡名称时都惊呆了，eno16777736，eno加数字的形式的网卡名，肿么变成这样。。  
需要变成eth0的方法有两种：  
一、在安装系统的界面时选择第一项（Install CentOS7 ) 然后按Tab键 ，在后尾加上  
net.ifnames=0 biosdevname=0 然后回车再进行安装系统。  
二、在安装系统后vim /etc/sysconfig/grub 在GRUB_CMDLINE_LINUX中增加net.ifnames=0
biosdevname=0  
GRUB_TIMEOUT=5  
GRUB_DISTRIBUTOR="\$(sed 's, release .\*\$,,g' /etc/system-release)"  
GRUB_DEFAULT=saved  
GRUB_DISABLE_SUBMENU=true  
GRUB_TERMINAL_OUTPUT="console"  
GRUB_CMDLINE_LINUX="crashkernel=auto net.ifnames=0 biosdevname=0 rhgb quiet"  
GRUB_DISABLE_RECOVERY="true  
增加后保存，然后再执行grub2-mkconfig -o /boot/grub2/grub.cfg
再去对应网卡把名称修改成eth0，重启系统即可。

4、主机名  
CentOS7后，主机名的修改可以在  
vim /etc/hostname 下修改

5、服务管理  
CentOS7后使用了systemd来代替sysvinit管理services  
systemctl是主要的工具，它融合之前service和chkconfig的功能于一体。可以使用它永久性或只在当前会话中启用/禁用服务。  
systemctl 动作 服务名.service  
启动一个服务：systemctl start httpd.service  
关闭一个服务：systemctl stop httpd.service  
重启一个服务：systemctl restart httpd.service  
显示一个服务的状态：systemctl status httpd.service  
在开机时启用一个服务：systemctl enable httpd.service  
在开机时禁用一个服务：systemctl disable httpd.service  
查看服务是否开机启动：systemctl is-enabled httpd.service;echo \$?  
查看已启动的服务列表：systemctl list-unit-files\|grep enabled

6、sysctl  
Sysctl是一个允许您改变正在运行中的Linux系统的接口  
在CentOS7下 /etc/sysctl.conf是空的，可以到/proc/sys/net下配置
