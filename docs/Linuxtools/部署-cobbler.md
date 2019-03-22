cobbler配置

https://www.cnblogs.com/linuxliu/p/7668048.html  
https://www.cnblogs.com/aaa103439/p/fee5af9f216ed0652233f46ad4937bdf.html  
  
安装Cobbler  
yum install epel-release -y  
yum -y install httpd dhcp tftp python-ctypes cobbler xinetd cobbler-web  
systemctl start httpd  
systemctl enable httpd  
systemctl enable cobblerd  
systemctl start cobblerd  
  
检查  
[root\@linux7 \~]\# cobbler check  
The following are potential configuration items that you may want to fix:  
  
1 : The 'server' field in /etc/cobbler/settings must be set to something other
than localhost, or kickstarres will not work. This should be a resolvable
hostname or IP for the boot server as reachable by all mac will use it.  
2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings
must be set to something ot27.0.0.1, and should match the IP of the boot server
on the PXE network.  
3 : change 'disable' to 'no' in /etc/xinetd.d/tftp  
4 : Some network boot-loaders are missing from /var/lib/cobbler/loaders, you may
run 'cobbler get-loaders'ad them, or, if you only want to handle x86/x86_64
netbooting, you may ensure that you have installed a \*rsion of the syslinux
package installed and can ignore this message entirely. Files in this directory,
shont to support all architectures, should include pxelinux.0, menu.c32,
elilo.efi, and yaboot. The 'cobbler s' command is the easiest way to resolve
these requirements.  
5 : enable and start rsyncd.service with systemctl  
6 : debmirror package is not installed, it will be required to manage debian
deployments and repositories  
7 : ksvalidator was not found, install pykickstart  
8 : The default password used by the sample templates for newly installed
machines (default_password_crypt/cobbler/settings) is still set to 'cobbler' and
should be changed, try: "openssl passwd -1 -salt 'random-e'
'your-password-here'" to generate new one  
9 : fencing tools were not found, and are required to use the (optional) power
management features. instalfence-agents to use them  
  
Restart cobblerd and then run 'cobbler sync' to apply changes.  
  
1、2 修改  
\# 修改server的ip地址为本机ip  
sed -i 's/\^server: 127.0.0.1/server: 10.0.0.101/' /etc/cobbler/settings  
\# TFTP Server 的IP地址  
sed -i 's/\^next_server: 127.0.0.1/next_server: 10.0.0.101/'
/etc/cobbler/settings  
  
3、修改  
cat /etc/xinetd.d/tftp \|grep disable  
disable = no  
systemctl restart tftp  
systemctl enable tftp  
  
4、运行下载缺失文件  
cobbler get-loaders  
......  
\*\*\* TASK COMPLETE \*\*\*  
  
5、添加rsync到自启动并启动rsync  
systemctl restart rsyncd  
systemctl enable rsyncd  
  
6、安装  
yum install debmirror -y  
  
7、安装  
yum install pykickstart -y  
  
8、生成账户密码  
openssl passwd -1 -salt "admin" "qqq111"  
\$1\$admin\$QogYDzL66Fg9hp59FR2A./  
vi /etc/cobbler/settings  
default_password_crypted: "\$1\$admin\$QogYDzL66Fg9hp59FR2A./"  
  
9、安装  
yum install fence-agents -y  
  
重启  
systemctl restart cobblerd  
  
检查  
cobbler check  
vi /etc/debmirror.conf  
注释掉  
\#\@dists="sid";  
\@sections="main,main/debian-installer,contrib,non-free";  
\#\@arches="i386";  
  
检查无错误  
cobbler check  
  
配置DHCP  
vi /etc/cobbler/settings  
manage_dhcp: 1 \# 修改settings中参数，由cobbler控制dhcp  
pxe_just_once: 1 \#仅安装一次  
修改dhcp.templates配置文件（仅列出修改部分）  
vi /etc/cobbler/dhcp.template  
subnet 10.1.2.0 netmask 255.255.255.0 {  
option routers 10.1.2.22;  
option domain-name-servers 10.1.2.22;  
option subnet-mask 255.255.255.0;  
range dynamic-bootp 10.1.2.100 10.1.2.120;  
  
systemctl restart cobblerd  
cobbler sync  
......  
\*\*\* TASK COMPLETE \*\*\*  
  
systemctl restart dhcpd  
systemctl enable dhcpd  
  
挂载  
mkdir /mnt/centos7  
mount /dev/cdrom /mnt/centos7/  
cd /mnt/centos7/  
cobbler 导入  
cobbler import --path=/mnt/centos7 --name=Centos-7.4 --arch=x86_64  
--path 镜像路径  
--name 为安装源定义一个名字  
--arch 指定安装源是32位、64位、ia64, 目前支持的选项有: x86│x86_64│ia64  
\#
安装源的唯一标示就是根据name参数来定义，本例导入成功后，安装源的唯一标示就是：CentOS-7.4-x86_64，如果重复，系统会提示导入失败  
Adding distros from path /var/www/cobbler/ks_mirror/Centos-7.4-x86_64: \#
导入镜像的位置  
查看镜像  
cobbler list  
查看导入信息和默认ks文件配置  
cobbler report  
  
查看  
\#http地址  
http://10.1.2.22/cobbler/ks_mirror/Centos-7.4-x86_64/  
cobbler profile list  
生成ks.cfg配置文件然后放到该路径下  
cd /var/lib/cobbler/kickstarts/  
修改指定ks为上传的ks  
\# 编辑profile，修改ks文件为我们刚刚上传的Centos-7.4-x86_64.cfg  
cobbler profile edit --name=Centos-7.4-x86_64
--kickstart=/var/lib/cobbler/kickstarts/Centos-7.4-x86_64.cfg  
\#
修改安装系统的内核参数，在CentOS7系统有一个地方变了，就是网卡名变成eno16777736这种形式，但是为了运维标准化，我们需要将它变成我们常用的eth0，因此使用上面的参数。但要注意是CentOS7才需要上面的步骤，CentOS6不需要。  
cobbler profile edit --name=Centos-7.4-x86_64 --kopts='net.ifnames=0
biosdevname=0'  
查看  
cobbler profile report  
  
检查ks命令  
\# 写完 ks 文件之后，先通过 validateks 测试一下有没有语法错误  
cobbler validateks  
\# 通过下面这个命令查看 ks 文件，发现一些逻辑上的问题  
cobbler system getks --name=test  
  
同步cobbler  
cobbler sync  
systemctl restart xinetd.service  
systemctl restart cobblerd.service  
systemctl restart httpd.service  
systemctl restart dhcpd  
systemctl restart rsyncd  
  
PS：  
引导界面中网址也可以定制为我们自己的  
[root\@localhost cobbler]\# vim /etc/cobbler/pxe/pxedefault.template  
MENU TITLE Cobbler \| I'm here \# 修改这里为你想修改的内容  
[root\@localhost cobbler]\# cobbler sync \# 同步之后就可以看到效果了  
  
通过MAC地址定制化安装  
我们可以根据不同的MAC地址来给安装
不同的操作系统，配置不同的静态iP,设置不同的主机名等等，虚拟机查看MAC地址：  
配置定制化安装（需要验证，后续验证后添加验证结果）  
[root\@localhost cobbler]\# cobbler system add \\  
--name=linux-web01 \\  
--mac=00:0C:29:3B:03:9B \\  
--profile=Centos-7.4-x86_64 \\  
--ip-address=10.0.0.200 \\  
--subnet=255.255.255.0 \\  
--gateway=10.0.0.2 \\  
--interface=eth0 \\  
--static=1 \\  
--hostname=linux-web01 \\  
--name-servers="10.1.2.22" \\  
--kickstart=/var/lib/cobbler/kickstarts/Centos-7.4-x86_64.cfg  
  
system add \# 添加定制系统  
name \# 定制系统名称  
mac \# mac地址  
profile \#指定profile  
ip-address \# 指定IP地址  
subnet \# 指定子网掩码  
gateway \# 指定网关  
interface \# 指定网卡，eth0上面配置已经修改，centos7默认网卡名称不是eth0  
static \# 1表示启用静态IP  
hostname \# 定义hostname  
name-server \# dns服务器  
kickstart \# 指定ks文件  
配置成功后我们可以查看到刚才定制的系统  
  
[root\@localhost cobbler]\# cobbler system list  
linux-web01接下来我们创建一个虚拟机，mac地址为00:0C:29:3B:03:9B，启动后你就会发现自动进入安装系统了，等安装完以后，所有的配置都和我们当初设置的一样。  
  
使用koan实现重新安装系统  
在客户端安装koan（要配置好源）  
  
[root\@localhost \~]\# rpm -ivh
http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm  
[root\@localhost \~]\# yum install koan  
查看cobbler上的配置文件  
1 [root\@localhost \~]\# koan --server=10.0.0.101 --list=profiles  
2 - looking for Cobbler at http://10.0.0.101:80/cobbler_api  
3 Centos-7.2-x86_64  
  
重新安装客户端系统  
[root\@localhost \~]\# koan --replace-self --server=10.0.0.101
--profile=webserver1  
重启系统后会自动重装系统
