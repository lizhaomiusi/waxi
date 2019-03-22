部署-PXE

https://www.cnblogs.com/chen110xi/p/5753590.html

环境配置  
VMware12

cdrom/images/pxeboot目录下  
CentOS-6.6-x86_64-bin-DVD1.iso、DHCP、TFTP、HTTP、kickstart  
  
关闭selinux 关闭防火墙和自启  
sed -i 's/SELINUX=.\*/SELINUX=disabled/g' /etc/selinux/config  
/etc/init.d/iptables stop  
chkconfig iptables off  
/etc/init.d/iptables status  
  
1、配置dhcp服务  
yum -y install dhcp  
chkconfig dhcpd on  
vi /etc/dhcp/dhcpd.conf  
  
subnet 192.168.12.0 netmask 255.255.255.0 {  
range 192.168.12.10 192.168.12.20;  
option subnet-mask 255.255.255.0;  
default-lease-time 21600;  
max-lease-time 43200;  
next-server 192.168.12.16;  
filename "/pxelinux.0";  
}  
\# 注释  
range 10.0.0.100 10.0.0.200; \# 可分配的起始IP-结束IP  
option subnet-mask 255.255.255.0; \# 设定netmask  
default-lease-time 21600; \# 设置默认的IP租用期限  
max-lease-time 43200; \# 设置最大的IP租用期限  
next-server 192.168.12.16; \# 告知客户端TFTP服务器的ip  
filename "/pxelinux.0"; \# 告知客户端从TFTP根目录下载pxelinux.0文件  
  
指定dhcp监听网卡  
vim /etc/sysconfig/dhcpd  
\# Command line options here  
DHCPDARGS=eth1 \# 指定监听网卡  
/etc/init.d/dhcpd restart  
  
ss -nul  
State Recv-Q Send-Q Local Address:Port Peer Address:Port  
UNCONN 0 0 \*:67 \*:\*  
并测试  
  
2、配置tftp服务  
yum -y install tftp tftp-server  
chkconfig xinetd on  
chkconfig tftp on  
vim /etc/xinetd.d/tftp  
disable = no \# 由原来的yes改为no  
/etc/init.d/xinetd restart  
ss -nul  
State Recv-Q Send-Q Local Address:Port Peer Address:Port  
UNCONN 0 0 \*:67 \*:\*  
UNCONN 0 0 \*:69 \*:\*  
并测试  
在/var/lib/tftpboot/下创建文件 然后下载  
[root\@centos6 \~]\# cd /var/lib/tftpboot/  
[root\@centos6 tftpboot]\# echo 123 \> 1.1  
[root\@centos6 tftpboot]\# cd \~  
[root\@centos6 \~]\# tftp 192.168.12.16  
tftp\> get 1.1  
tftp\> q  
[root\@centos6 \~]\# cat 1.1  
123  
  
3、配置http服务  
yum -y install httpd  
chkconfig httpd on  
/etc/init.d/httpd restart  
  
创建/media/cdrom
目录并将系统安装光盘挂载至该目录，然后复制到/var/www/html/cdrom下，通过http服务器为pxe客户端提供安装源和ks文件  
mkdir /media/cdrom  
mkdir /var/www/html/cdrom  
mount -r /dev/cdrom /media/cdrom  
cp -r /media/cdrom/ /var/www/html/cdrom/  
访问测试  
\# 挂载光盘 卸载用umount /media/cdrom  
PS注意 光盘不识别部分文件后缀，会报错，需要全部复制到指定文件夹下  
  
4、PXE引导配置（bootstrap）和配置kickstart服务 需要桌面环境支持同时安装桌面环境  
yum -y install syslinux  
yum groupinstall "X Window System" -y  
yum groupinstall "Desktop" -y  
yum install system-config-kickstart -y  
  
其他默认保存到/vat/www/html下修改repo源地址  
vi /var/www/html/ks.cfg  
repo --name="CentOS" --baseurl=http://192.168.12.16/cdrom --cost=100  
  
5、提供PXE工作环境必须、内核以及其它所需  
首先，我们要将能够通过网络引导系统安装的文件pxelinux.0(类似于grub，是一种引导程序，但是它专为pxe模式下的网络系统部署提供引导  
找到/usr/share/syslinux/pxelinux.0文件，并将其复制到/var/lib/tftpboot/目录下。  
yum -y install syslinux  
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/  
  
将系统光盘镜像中的isolinux/目录下的{boot.msg,splash.jpg,vesamenu.c32}复制到/var/lib/tftpboot/目录下  
cp /var/www/html/cdrom/isolinux/{boot.msg,splash.jpg,vesamenu.c32}
/var/lib/tftpboot/  
  
将系统镜像盘/cdrom/images/pxeboot中pxe模式下专用的内核文件和initrd镜像文件件复制到tftp服务器相应目录中，  
cp /var/www/html/cdrom/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/  
  
2、将系统光盘镜像中的isolinux/目录下的isolinux.cfg文件拷贝至/var/lib/tftpboot/pxelinux.cfg/目录下，命名为default,用来引导客户端启动过程。  
mkdir /var/lib/tftpboot/pxelinux.cfg  
cp /var/www/html/cdrom/isolinux/isolinux.cfg
/var/lib/tftpboot/pxelinux.cfg/default  
  
vi /var/lib/tftpboot/pxelinux.cfg/default  
label linux  
menu label \^Install or upgrade an existing system  
menu default  
kernel vmlinuz  
append initrd=initrd.img text ks=http://192.168.12.16/ks.cfg  
  
PS:若提示错误unable to read package metadata  
找到/vat/www/html/ks.cfg  
修改repo源地址或者\#掉  
url --url="http://192.168.12.16/cdrom"  
repo --name="CentOS" --baseurl=http://192.168.12.16/cdrom --cost=100

ks.cfg制作过程  
运行kickstart-打开root目录-\>anaconda-ks.cfg

基本配置

给根加口令

勾选：安装后重新引导，在文本模式中执行安装（默认为图形化模式）

安装方法

勾选：执行新安装

http服务器：http://10.1.2.70

http目录：yum

引导装在程序选项

勾选：安装新引导装载程序，在主引导记录（MBR）上安装引导装载程序

分区信息

勾选：清除主引导记录，删除所有现存分区，初始化硬盘标签

添加分区信息一般

/boot ext4 200-500

swap swap 内存x2

/ ext4 10G

防火墙配置：禁用
