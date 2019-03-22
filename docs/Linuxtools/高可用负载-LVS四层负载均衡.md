LVS四层负载均衡

LVS是 Linux Virtual Server 的简称，也就是Linux虚拟服务器。

http://zh.linuxvirtualserver.org/ \# LVS中文站点  
https://www.cnblogs.com/liwei0526vip/p/6370103.html  
http://www.cnblogs.com/klb561/p/9215704.html  
https://www.cnblogs.com/lixigang/p/5371815.html  
http://www.cnblogs.com/clsn/p/7920637.html  
https://www.jianshu.com/p/d9f288653039  
https://www.cnblogs.com/lixigang/p/5371815.html  
https://www.cnblogs.com/liwei0526vip/p/6370103.html  
  
LVS基本介绍  
LB集群的架构和原理很简单，就是当用户的请求过来时，会直接分发到Director
Server上，然后它把用户的请求根据设置好的调度算法，智能均衡地分发到后端真正服务器(real
server)上。为了避免不同机器上用户请求得到的数据不一样，需要用到了共享存储，这样保证所有用户请求的数据是一样的。  
LVS是 Linux Virtual Server
的简称，也就是Linux虚拟服务器。这是一个由章文嵩博士发起的一个开源项目，它的官方网站是
http://www.linuxvirtualserver.org 现在 LVS 已经是 Linux 内核标准的一部分。使用
LVS 可以达到的技术目标是：通过 LVS 达到的负载均衡技术和 Linux
操作系统实现一个高性能高可用的 Linux
服务器集群，它具有良好的可靠性、可扩展性和可操作性。从而以低廉的成本实现最优的性能。LVS
是一个实现负载均衡集群的开源软件项目，LVS架构从逻辑上可分为调度层、Server集群层和共享存储。  
  
LVS的基本工作原理  
  
1. 当用户向负载均衡调度器（Director Server）发起请求，调度器将请求发往至内核空间  
2. PREROUTING链首先会接收到用户请求，判断目标IP确定是本机IP，将数据包发往INPUT链  
3.
IPVS是工作在INPUT链上的，当用户请求到达INPUT时，IPVS会将用户请求和自己已定义好的集群服务进行比对，如果用户请求的就是定义的集群服务，那么此时IPVS会强行修改数据包里的目标IP地址及端口，并将新的数据包发往POSTROUTING链  
4.
POSTROUTING链接收数据包后发现目标IP地址刚好是自己的后端服务器，那么此时通过选路，将数据包最终发送给后端的服务器  
  
LVS的组成  
LVS 由2部分程序组成，包括 ipvs 和 ipvsadm。  
1. ipvs(ip virtual
server)：一段代码工作在内核空间，叫ipvs，是真正生效实现调度的代码。  
2.
ipvsadm：另外一段是工作在用户空间，叫ipvsadm，负责为ipvs内核框架编写规则，定义谁是集群服务，而谁是后端真实的服务器(Real
Server)  
  
  
LVS相关术语  
1. DS：Director Server。指的是前端负载均衡器节点。  
2. RS：Real Server。后端真实的工作服务器。  
3. VIP：向外部直接面向用户请求，作为用户请求的目标的IP地址。  
4. DIP：Director Server IP，主要用于和内部主机通讯的IP地址。  
5. RIP：Real Server IP，后端服务器的IP地址。  
6. CIP：Client IP，访问客户端的IP地址。  
  
LVS的八种调度算法  
1. 轮叫调度 rr  
这种算法是最简单的，就是按依次循环的方式将请求调度到不同的服务器上，该算法最大的特点就是简单。轮询算法假设所有的服务器处理请求的能力都是一样的，调度器会将所有的请求平均分配给每个真实服务器，不管后端
RS 配置和处理能力，非常均衡地分发下去。  
2. 加权轮叫 wrr  
这种算法比 rr 的算法多了一个权重的概念，可以给 RS
设置权重，权重越高，那么分发的请求数越多，权重的取值范围 0 -
100。主要是对rr算法的一种优化和补充， LVS
会考虑每台服务器的性能，并给每台服务器添加要给权值，如果服务器A的权值为1，服务器B的权值为2，则调度到服务器B的请求会是服务器A的2倍。权值越高的服务器，处理的请求越多。  
3. 最少链接 lc  
这个算法会根据后端 RS 的连接数来决定把请求分发给谁，比如 RS1 连接数比 RS2
连接数少，那么请求就优先发给 RS1  
4. 加权最少链接 wlc  
这个算法比 lc 多了一个权重的概念。  
5. 基于局部性的最少连接调度算法 lblc  
这个算法是请求数据包的目标 IP 地址的一种调度算法，该算法先根据请求的目标 IP
地址寻找最近的该目标 IP
地址所有使用的服务器，如果这台服务器依然可用，并且有能力处理该请求，调度器会尽量选择相同的服务器，否则会继续选择其它可行的服务器  
6. 复杂的基于局部性最少的连接算法 lblcr  
记录的不是要给目标 IP 与一台服务器之间的连接记录，它会维护一个目标 IP
到一组服务器之间的映射关系，防止单点服务器负载过高。  
7. 目标地址散列调度算法 dh  
该算法是根据目标 IP 地址通过散列函数将目标 IP
与服务器建立映射关系，出现服务器不可用或负载过高的情况下，发往该目标 IP
的请求会固定发给该服务器。  
8. 源地址散列调度算法 sh  
与目标地址散列调度算法类似，但它是根据源地址散列算法进行静态分配固定的服务器资源。

LVS/NAT原理和特点  
1. 重点理解NAT方式的实现原理和数据包的改变。  
  
(a). 当用户请求到达Director
Server，此时请求的数据报文会先到内核空间的PREROUTING链。
此时报文的源IP为CIP，目标IP为VIP  
(b). PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链  
(c).
IPVS比对数据包请求的服务是否为集群服务，若是，修改数据包的目标IP地址为后端服务器IP，然后将数据包发至POSTROUTING链。
此时报文的源IP为CIP，目标IP为RIP  
(d). POSTROUTING链通过选路，将数据包发送给Real Server  
(e). Real Server比对发现目标为自己的IP，开始构建响应报文发回给Director Server。
此时报文的源IP为RIP，目标IP为CIP  
(f). Director
Server在响应客户端前，此时会将源IP地址修改为自己的VIP地址，然后响应给客户端。
此时报文的源IP为VIP，目标IP为CIP  
  
2. LVS-NAT模型的特性  
• RS应该使用私有地址，RS的网关必须指向DIP  
• DIP和RIP必须在同一个网段内  
• 请求和响应报文都需要经过Director Server，高负载场景中，Director
Server易成为性能瓶颈  
• 支持端口映射  
• RS可以使用任意操作系统  
• 缺陷：对Director Server压力会比较大，请求和响应都需经过director server  
  
例子：  
1.使用NAT模式  
添加地址为207.175.44.110:80的虚拟服务，指定调度算法为轮转。  
ipvsadm -A -t 207.175.44.110:80 -s wrr  
ipvsadm -a -t 207.175.44.110:80 -r 192.168.10.1:80 -m -w 3  
ipvsadm -a -t 207.175.44.110:80 -r 192.168.10.2:80 -m -w 5  
-A：规定发往本机哪个IP:PORT的报文是需要被调度的  
-a：为某个调度规则添加Real Server  
-t：tcp协议请求  
-s：定义调度规则  
-m：表示采用lvs-nat工作模式，默认为lvs-dr工作模式  
-w：调度规则是wrr（带权重的轮询）用-w 定义Real Server的权重  
  
NAT模式是lvs的三种模式中最简单的一种。此种模式下只需要保证调度服务器与真实服务器互通就可以运行。  
---  
六、LVS/DR原理和特点  
1. 重将请求报文的目标MAC地址设定为挑选出的RS的MAC地址  
  
(a) 当用户请求到达Director
Server，此时请求的数据报文会先到内核空间的PREROUTING链。
此时报文的源IP为CIP，目标IP为VIP  
(b) PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链  
(c)
IPVS比对数据包请求的服务是否为集群服务，若是，将请求报文中的源MAC地址修改为DIP的MAC地址，将目标MAC地址修改RIP的MAC地址，然后将数据包发至POSTROUTING链。
此时的源IP和目的IP均未修改，仅修改了源MAC地址为DIP的MAC地址，目标MAC地址为RIP的MAC地址  
(d)
由于DS和RS在同一个网络中，所以是通过二层来传输。POSTROUTING链检查目标MAC地址为RIP的MAC地址，那么此时数据包将会发至Real
Server。  
(e)
RS发现请求报文的MAC地址是自己的MAC地址，就接收此报文。处理完成之后，将响应报文通过lo接口传送给eth0网卡然后向外发出。
此时的源IP地址为VIP，目标IP为CIP  
(f) 响应报文最终送达至客户端  
  
2. LVS-DR模型的特性  
• 特点1：保证前端路由将目标地址为VIP报文统统发给Director Server，而不是RS  
•
RS可以使用私有地址；也可以是公网地址，如果使用公网地址，此时可以通过互联网对RIP进行直接访问  
• RS跟Director Server必须在同一个物理网络中  
• 所有的请求报文经由Director Server，但响应报文必须不能进过Director Server  
• 不支持地址转换，也不支持端口映射  
• RS可以是大多数常见的操作系统  
• RS的网关绝不允许指向DIP(因为我们不允许他经过director)  
• RS上的lo接口配置VIP的IP地址  
• 缺陷：RS和DS必须在同一机房中  
  
3. 特点1的解决方案：  
• 在前端路由器做静态地址路由绑定，将对于VIP的地址仅路由到Director Server  
•
存在问题：用户未必有路由操作权限，因为有可能是运营商提供的，所以这个方法未必实用  
•
arptables：在arp的层次上实现在ARP解析时做防火墙规则，过滤RS响应ARP请求。这是由iptables提供的  
•
修改RS上内核参数（arp_ignore和arp_announce）将RS上的VIP配置在lo接口的别名上，并限制其不能响应对VIP地址解析请求。  
  
使用DR模式  
对于DR模式首先要配置真实服务器：  
对于每台真实服务器要进行以下操作：  
1、设置真实服务器的lo接口不做ARP应答  
echo 1 \> /proc/sys/net/ipv4/conf/all/arg_ignore  
echo 1 \> /proc/sys/net/ipv4/conf/lo/arg_ignore  
设置这个选项可以使得各个接口只对本接口上的地址进行响应  
还需要设置arp_announce选项为2，设置方法同上  
2、在真实服务器上添加虚拟IP  
ifconfig lo:0 192.168.10.10 boradcast 207.175.44.110 netmask 255.255.255.255  
ip r add 192.168.10.10 dev lo  
接着添加ipvs规则：  
添加地址为192.168.10.10:80的虚拟服务，指定调度算法为轮转。  
ipvsadm -A -t 192.168.10.10:80 -s rr  
添加真实服务器，指定传输模式为DR  
ipvsadm -a -t 192.168.10.10:80 -r 192.168.10.1:80 -g  
ipvsadm -a -t 192.168.10.10:80 -r 192.168.10.2:80 -g  
ipvsadm -a -t 192.168.10.10:80 -r 192.168.10.3:80 -g  
注意：此处的例子中客户、调度服务器、真实服务器都是位于同一网段的

LVS/Tun原理和特点  
在原有的IP报文外再次封装多一层IP首部，内部IP首部(源地址为CIP，目标IIP为VIP)，外层IP首部(源地址为DIP，目标IP为RIP)  
\#  
(a) 当用户请求到达Director
Server，此时请求的数据报文会先到内核空间的PREROUTING链。
此时报文的源IP为CIP，目标IP为VIP 。  
(b) PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链  
(c)
IPVS比对数据包请求的服务是否为集群服务，若是，在请求报文的首部再次封装一层IP报文，封装源IP为为DIP，目标IP为RIP。然后发至POSTROUTING链。
此时源IP为DIP，目标IP为RIP  
(d)
POSTROUTING链根据最新封装的IP报文，将数据包发至RS（因为在外层封装多了一层IP首部，所以可以理解为此时通过隧道传输）。
此时源IP为DIP，目标IP为RIP  
(e)
RS接收到报文后发现是自己的IP地址，就将报文接收下来，拆除掉最外层的IP后，会发现里面还有一层IP首部，而且目标是自己的lo接口VIP，那么此时RS开始处理此请求，处理完成之后，通过lo接口送给eth0网卡，然后向外传递。
此时的源IP地址为VIP，目标IP为CIP  
(f) 响应报文最终送达至客户端  
  
LVS-Tun模型特性  
• RIP、VIP、DIP全是公网地址  
• RS的网关不会也不可能指向DIP  
• 所有的请求报文经由Director Server，但响应报文必须不能进过Director Server  
• 不支持端口映射  
• RS的系统必须支持隧道  
  
其实企业中最常用的是 DR 实现方式，而 NAT 配置上比较简单和方便，后边实践中会总结
DR 和 NAT 具体使用配置过程。

ipvsadm命令  
-A --add-service在服务器列表中新添加一条新的虚拟服务器记录  
-t 表示为tcp服务  
-u 表示为udp服务  
-s --scheduler 使用的调度算法， rr \| wrr \| lc \| wlc \| lblb \| lblcr \| dh \|
sh \| sed \| nq 默认调度算法是 wlc  
ipvsadm -a -t 192.168.3.187:80 -r 192.168.200.10:80 -m -w 1  
-a --add-server 在服务器表中添加一条新的真实主机记录  
-t --tcp-service 说明虚拟服务器提供tcp服务  
-u --udp-service 说明虚拟服务器提供udp服务  
-r --real-server 真实服务器地址  
-m --masquerading 指定LVS工作模式为NAT模式  
-g --gatewaying 指定LVS工作模式为直接路由器模式（也是LVS默认的模式）DR模式  
-w --weight 真实服务器的权值 -w 1  
-i --ipip 指定LVS的工作模式为隧道模式  
-p
会话保持时间，定义流量呗转到同一个realserver的会话存留时间，会话保持20秒只找这台
-p 20  
--set 30 5 60 \# 添加超时  
-C \# 清除所有创建的集群  
-E \# 修改定义过的集群服务  
-D \# -t\|-u\|-f server-address：删除指定的集群服务  
-L \#查看  
-n \# 数字格式显示IP  
-c \# 连接数相关信息  
-L -n -c \# 查看连接情况  
-L -n --stats \# 查看分发情况  
-L -n --rate \# 查看速率  
-L -n --exact \# 显示统计数据精确值  
-Z \# --zero 清空连接计数  
例：  
ipvsadm -A -t 192.168.8.252:80 -s wrr -p 20 \# 添加 分发服务器  
ipvsadm -D -t 192.168.8.252:80 -s wrr \# 删除  
ipvsadm -E -t 192.168.8.252:80 -s rr \# 修改  
ipvsadm -Ln \# 查看规则  
ipvsadm -C \# 清空规则  
ipvsadm -a -t 192.168.8.252:80 -r 192.168.8.83 -g \# 添加真实服务器  
ipvsadm -d -t 192.168.8.252:80 -r 192.168.8.83 \# 删除真实服务器  
ipvsadm -S \> ipvsadm.txt \# 备份  
ipvsadm -R \< ipvsadm.txt \# 还原  
\#  
/etc/init.d/ipvsadm save \# 保存  
cat /etc/sysconfig/ipvsadm \# 配置文件地址

LVS的NAT转发模式  
环境  
director\*2  
外网 192.168.10.99  
内网 10.1.2.13/24  
real server 10.1.2.14/24 GW 10.1.2.13  
real server 10.1.2.15/24 GW 10.1.2.13  
\#  
安装和配置  
\#两个 real server 上都安装 nginx 服务  
yum install -y nginx  
\#Director 上安装 ipvsadm  
yum install -y ipvsadm

Director上 nat 实现脚本  
vim /usr/local/sbin/lvs_nat.sh  
\#! /bin/bash  
  
\# director服务器上开启路由转发功能，临时生效  
echo 1 \> /proc/sys/net/ipv4/ip_forward  
\#永久生效，修改sysctl.conf：  
\#vim /etc/sysctl.conf  
\#net.ipv4.ip_forward = 1 \# 原0改为1  
\#sysctl -p \# 执行马上生效  
  
\# 关闭 icmp 的重定向，临时生效  
echo 0 \> /proc/sys/net/ipv4/conf/all/send_redirects  
echo 0 \> /proc/sys/net/ipv4/conf/default/send_redirects  
echo 0 \> /proc/sys/net/ipv4/conf/eth0/send_redirects  
echo 0 \> /proc/sys/net/ipv4/conf/eth1/send_redirects  
  
\# director设置 ipvsadm  
IPVSADM='/sbin/ipvsadm'  
VIP1='192.168.10.99'  
RS1='10.1.2.14'  
RS2='10.1.2.15'  
\$IPVSADM -C  
  
\# 添加分发服务器  
\$IPVSADM -A -t \$VIP1:80 -s wrr  
\$IPVSADM -a -t \$VIP1:80 -r \$RS1:80 -m -w 1  
\$IPVSADM -a -t \$VIP1:80 -r \$RS2:80 -m -w 1  
  
\# director设置 nat 防火墙 放行  
iptables -t nat -F  
iptables -t nat -X  
iptables -t nat -A POSTROUTING -s 10.1.2.0/24 -j MASQUERADE

PS：  
注意，切记一定要在两台 RS 上设置网关的 IP 为 director 的内网 IP。  
\# 保存  
/etc/init.d/ipvsadm save  
\#查看ipvsadm设置的规则  
ipvsadm -Ln  
  
yum install elinks -y  
elinks 192.168.21.60 --dump \# 测试

DR（直接路由模式）（常用）  
环境  
Director节点 eth0 10.1.2.13/24 vip eth0:1 10.1.2.100/32  
Real server1 eth0 10.1.2.14/24 vip lo:1 10.1.2.100/32  
Real server2 eth0 10.1.2.15/24 vip lo:1 10.1.2.100/32  
  
永久生效，修改网卡配置文件（常用）  
vi /etc/sysconfig/network-scripts/ifcfg-eth0:1  
临时配置  
ifconfig lo:1 10.1.2.100/32 up \# 可写入/etc/rc.local开机自启  
route add -host 10.0.0.10 dev eth0 \# 添加主机路由 可选  
会出现错误已存地址找到解决两台rs上关闭ARP广播配置在下  
  
配置LVS  
\#! /bin/bash  
echo 1 \> /proc/sys/net/ipv4/ip_forward  
IPV='/sbin/ipvsadm'  
VIP1='10.1.2.100'  
RS1='10.1.2.14'  
RS2='10.1.2.15'  
ifconfig eth0:1 down  
ifconfig eth0:1 \$VIP1 broadcast \$VIP1 netmask 255.255.255.255 up  
route add -host \$VIP1 dev eth0:1  
\$IPV -C  
\$IPV -A -t \$VIP1:80 -s wrr  
\$IPV -a -t \$VIP1:80 -r \$RS1:80 -g -w 3  
\$IPV -a -t \$VIP1:80 -r \$RS2:80 -g -w 1  
  
配置两台RS  
安装nginx服务  
yum install nginx -y  
  
\#! /bin/bash  
VIP1='10.1.2.100'  
RS=\`ifconfig \|sed -n '2p' \|awk -F'[: ]+' '{print \$4}'\`  
ifconfig lo:1 \$VIP1/32 up  
route add -host \$VIP1 lo:0  
echo \$RS \> /usr/share/nginx/html/index.html  
\#服务器地址冲突 在两台RS上关闭ARP转发，临时生效  
echo "1" \>/proc/sys/net/ipv4/conf/lo/arp_ignore  
echo "2" \>/proc/sys/net/ipv4/conf/lo/arp_announce  
echo "1" \>/proc/sys/net/ipv4/conf/all/arp_ignore  
echo "2" \>/proc/sys/net/ipv4/conf/all/arp_announce  
ifconfig lo:1 10.1.2.100/32 up \# 可写入/etc/rc.local开机自启  
修改网卡配置文件永久生效（常用）  
vi /etc/sysconfig/network-scripts/lo:1  
  
永久生效  
vi /etc/sysctl.conf \# 最后添加  
net.ipv4.conf.lo.arp_ignore = 1  
net.ipv4.conf.lo.arp_announce = 2  
net.ipv4.conf.all.arp_ignore = 1  
net.ipv4.conf.all.arp_announce = 2  
sysctl -p

PS：  
高可用负载均衡切换的时候 要考虑ARP缓存的问题  
ARP 广播进行新的地址解析  
具体清空缓存命令  
/sbin/arping -I eth0 -c 3 -s 10.0.0.162  
/sbin/arping -U -I eth0 10.0.0.162

AB网站测试工具  
-n \# 测试会话中所执行的请求总个数，默认执行一个请求  
-c \# 一次产生的请求个数，默认是一次一个  
1.独立安装  
ab运行需要依赖apr-util包，安装命令为：  
yum install apr-util -y  
因为在后面的命令中要用到yumdownload，如果没有找到 yumdownload
命令可以使用以下命令安装依赖 yum-utils中的yumdownload 工具  
yum install yum-utils -y  
2.安装完成后执行以下指令  
解开后就能得到独立的 ab可执行文件了。  
操作完成后 将会产生一个 usr 目录 ab文件就在这个usr/bin 目录中  
cd /opt  
mkdir abtmp  
cd ./abtmp  
yum install yum-utils.noarch  
yumdownloader httpd-tools\*  
rpm2cpio httpd-\*.rpm \| cpio -idmv  
ln -s /opt/abtmp/usr/bin/ab /usr/local/bin/ab  
ab -n 1000 -c 1000 http://10.1.2.100

配置IP-TUN模式 \# 隧道模式 异地容灾  
\#DNS view 只能DNS 定位地域就近访问，例如在武汉就定位到武汉，在上海定位到上海  
  
环境  
DR=10.1.2.12  
VIP=10.1.2.100  
RIP1=10.1.2.13  
RIP2=10.1.2.14  
RIP3=10.1.2.15  
DR配置  
ifconfig eth0:0 \$VIP broadcast \$VIP netmask 255.255.255.255 up  
开启路由转发功能  
echo 1 \> /proc/sys/net/ipv4/ip_forward  
配置tun模式  
/sbin/ipvsadm -C  
/sbin/ipvsadm -A -t \$VIP:80 -s rr  
/sbin/ipvsadm -a -t \$VIP:80 -r \$RIP1:80 -i  
/sbin/ipvsadm -a -t \$VIP:80 -r \$RIP2:80 -i  
/sbin/ipvsadm -a -t \$VIP:80 -r \$RIP3:80 -i  
ipvsadm -L -n  
  
RS配置都是一样  
  
1、临时加载  
VIP=10.1.2.100  
ifconfig tunl0 \$VIP netmask 255.255.255.255 \# 默认加载ipip隧道  
永久生效  
modprobe ipip \# 执行会加载模块加载完会出现tunl0隧道  
添加网卡修改地址  
[root\@centos6 network-scripts]\# vi ifcfg-tunl0  
DEVICE=tunl0  
IPADDR=10.1.2.100  
NETMASK=255.255.255.255  
\# If you're having problems with gated making 127.0.0.0/8 a martian,  
\# you can change this to something else (255.255.255.255, for example)  
ONBOOT=yes  
NAME=tunl0  
  
关闭ARP相转发  
临时  
echo '0' \> /proc/sys/net/ipv4/ip_forward  
echo '1' \> /proc/sys/net/ipv4/conf/tunl0/arp_ignore  
echo '2' \> /proc/sys/net/ipv4/conf/tunl0/arp_announce  
echo '1' \> /proc/sys/net/ipv4/conf/all/arp_ignore  
echo '2' \> /proc/sys/net/ipv4/conf/all/arp_announce  
\#rp_filter用于反向过滤技术，也就是uRPF，他验证反向数据包的流向，以避免伪装IP攻击  
echo '0' \> /proc/sys/net/ipv4/conf/tunl0/rp_filter  
echo '0' \> /proc/sys/net/ipv4/conf/all/rp_filter  
  
永久生效  
net.ipv4.conf.tunl0.arp_ignore = 1  
net.ipv4.conf.tunl0.arp_announce = 2  
net.ipv4.conf.all.arp_ignore = 1  
net.ipv4.conf.all.arp_announce = 2  
net.ipv4.conf.tunl0.rp_filter = 0  
  
安装web  
yum install httpd -y  
开始测试

PS：arp解释  
https://www.cnblogs.com/lipengxiang2009/p/7451050.html  
\#arp_ignore的作用是控制系统在收到外部的arp请求时，是否要返回arp响应。  
　　arp_ignore参数常用的取值主要有0，1，2，3\~8较少用到：  
0：响应任意网卡上接收到的对本机IP地址的arp请求（包括环回网卡上的地址），而不管该目的IP是否在接收网卡上。  
1：只响应目的IP地址为接收网卡上的本地地址的arp请求。  
2：只响应目的IP地址为接收网卡上的本地地址的arp请求，并且arp请求的源IP必须和接收网卡同网段。  
3：如果ARP请求数据包所请求的IP地址对应的本地地址其作用域（scope）为主机（host），则不回应ARP响应数据包，如果作用域为全局（global）或链路（link），则回应ARP响应数据包。  
4\~7：保留未使用  
8：不回应所有的arp请求  
　　sysctl.conf中包含all和eth/lo（具体网卡）的arp_ignore参数，取其中较大的值生效。  
  
\#arp_announce的作用是控制系统在对外发送arp请求时，如何选择arp请求数据包的源IP地址。  
arp_announce参数常用的取值有0，1，2。  
0：允许使用任意网卡上的IP地址作为arp请求的源IP，通常就是使用数据包a的源IP。  
1：尽量避免使用不属于该发送网卡子网的本地地址作为发送arp请求的源IP地址。  
2：忽略IP数据包的源IP地址，选择该发送网卡上最合适的本地地址作为arp请求的源IP地址。  
　　sysctl.conf中包含all和eth/lo（具体网卡）的arp_ignore参数，取其中较大的值生效。
