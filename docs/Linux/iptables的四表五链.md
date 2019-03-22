Linux防火墙iptables规则设置

iptables命令是Linux上常用的防火墙软件，是netfilter项目的一部分。可以直接配置，也可以通过许多前端和图形界面配置。  
https://www.cnblogs.com/whych/p/9147900.html  
https://www.cnblogs.com/clsn/p/8308678.html  
  
四表五链  
规则表  
filter \# 包过滤，用于防火墙规则。  
net \# 地址转换，用于网关路由器。  
mangle \# 数据包修改（QOS），用于实现服务质量。  
raw \# 高级功能，如：网址过滤。  
规则链  
INPUT链 \# 入方向  
OUTPUT链 \# 出方向  
FORWARD链 \# 经过linux系统路由的数据包  
PREROUTING链 \# 用于修改目的地址（DNAT）  
POSTROUTING链 \# 用于修改源地址（SNAT）  
动作  
accept \# 允许数据包  
DROP \# 拒绝数据包  
REJECT \# 拒绝数据包，并通知对方  
REDIRECT \# 端口重定向、映射、透明代理  
SNAT \# 源地址转换  
DNAT \# 目标地址转换  
MASQUERADE \# IP伪装（NAT），用于ADSL  
LOG \# 日志记录  
-j LOG: 记录日志  
　　--log-level  
　　--log-prefix  
　　--log-tcp-sequence  
　　--log-uid  
　　--log-ip-options:记录ip选项信息  
　eg：记录哪一刻，谁发起了ping请求  
　　　　iptables -I INPUT 4 -d 172.16.100.7 -p icmp --icmp-type 8 -j LOG
--log-prefix "----firewall log for icmp----"  
　　　　//将保存在 /var/log/messages  
  
规则表的先后顺序:raw→mangle→nat→filter  
规则链的先后顺序:  
入站顺序:PREROUTING→INPUT  
出站顺序:OUTPUT→POSTROUTING  
转发顺序:PREROUTING→FORWARD→POSTROUTING  
  
  
语法参数  
在iptables中所有链名必须大写，表明必须小写，动作必须大写，匹配必须小写。  
iptables [-t 表名] \<-A\|D\|I\|R\> 链名 [规则编号] [-i\|o 网卡名称] [-p
协议类型] [-s 源地址\|源子网] [--sport 源端口号] [-d 目标ip地址\|目标子网]
[--dport 目标端口号] \<-j 动作\>  
参数  
[-t 表名]：指定要操作的表,默认filter表  
-A：在规则列表中新增一条规则,默认添加到尾部  
-D：删除规则，可以跟完整的规则描述，也可跟规则编号  
-I：插入一条规则，默认在第一条规则前插入,可以指定插入位置如:-I INPUT 3  
-R：替换某条规则，不会改变规则顺序，但必须要指定替换的规则编号  
-v：显示详细信息  
-n：以数字形式显示IP和端口。一般与-v连用  
-E：重新命名自定义链  
-F：清除规则链中已有的条目  
-X：删除自定义空链，如果链里面有规则，则无法删除  
-Z：清空规则链中的数据包计算器和字节计数器  
-N：创建新的用户自定义规则链  
-P：定义规则链中的默认目标  
-p：指定要匹配的数据包协议类型  
-s：指定要匹配的数据包源ip地址  
-d：指定要匹配的数据包目标IP地址  
-j\<目标\>：指定要跳转的目标,指定动作  
-i\<网络接口\>：指定数据包进入本机的网络接口  
-o\<网络接口\>：指定数据包要离开本机所使用的网络接口  
-L：显示指定表中的所有规则  
-n：以数字格式显示主机地址和端口号  
-v：显示详细信息  
-vv：显示更详细信息  
-x：显示精确值  
--line-numbers:显示规则号  
-h：显示帮助信息  
  
input方式总结： dport指本地，sport指外部。  
output行为总结：dport指外部，sport指本地。

比如要删除INPUT里序号为8的规则，  
先以编号查询然后删除  
iptables -L -n --line-numbers  
iptables -D INPUT 8  
  
iptables常用命令  
iptables -L -n -v \# 查看已添加的iptables规则,带上-v参数，会显示in out  
iptables-save \>/home/pi/iptables.bak \# 备份规则到指定目录的指定文件  
iptables-restore \</home/pi/iptables.bak \# 恢复指定文件的规则  
service iptables save \# 配置保存到/etc/sysconfig/iptables 永久生效  
  
示例  
iptables -P INPUT ACCEPT\|DROP \# 定义默认规则库入流量全部,放行或拒绝  
iptables -P OUTPUT ACCEPT\|DROP \# 定义默认规则库出流量全部,放行或拒绝  
\# 允许访问22端口 -A新增 -p指定协议tcp --dport指定端口80 -j指定动作放行或拒绝  
iptables -I INPUT -p tcp --dport 80 -j ACCEPT\|DROP  
  
对IP  
iptables -I INPUT -s 123.45.6.7 -j ACCEPT\|DROP \# 单个IP,放行或拒绝  
iptables -I INPUT -s 123.45.6.0/24 -j ACCEPT\|DROP \# IP段,放行或拒绝  
\# 开放或拒绝从eth0口进入且源地址为10.1.2.0/24网段发往本机的80端口的数据  
iptables -I INPUT -i eth1 -s 10.1.3.0/24 -p tcp --dport 80 -j ACCEPT\|DROP  
  
除10.0.0.0网段可以进行连接服务器主机意外，其余网段都禁止  
第一种方式：  
iptables -A INPUT -s 10.0.0.0/24 -d 172.16.1.8 -j ACCEPT  
修改默认规则，将默认规则改为拒绝  
第二种方式：  
! \# 表示对规则信息进行取反  
iptables -A INPUT ! -s 10.0.0.0/24 -d 172.16.1.8 -j DROP  
  
测试匹配列举端口范围。  
iptables -A INPUT -p tcp --dport 22:80 -j DROP \# 设置连续多端口控制策略  
iptables -A INPUT -p tcp -m multiport --dport 22,80 -j DROP \#
设置不连续多端口控制策略  
-m 参数表示增加扩展匹配功能，multiport 实现不连续多端口扩展匹配  
  
NAT地址转换  
echo 1 \> /proc/sys/net/ipv4/ip_forward \#临时  
vi /etc/sysctl.conf \#永久  
net.ipv4.ip_forward = 1  
网关打开转发功能之后，两个网段的主机便可通信，但是为什么还要NAT地址转换呢  
主要是接入外网的时候，虽然报文能发出去，但是如果不做地址转换，响应报文回不来，不像这里的两个网段这么简单，报文能回来是因为路由的原因  
所以配置防火墙策略  
首先清空策略  
iptables -t nat -F  
iptables -t nat -X  
NAT地址转换 -t指定表 -A新增SNAT -s指定源地址 -j动作动态转换外网地址  
iptables -t nat -A POSTROUTING -s 10.1.3.0/24 -j MASQUERADE  
  
地址转换  
iptables -t nat -A POSTROUTING -s 10.1.3.0/24 -o eth0 -j SNAT --to-source
10.1.2.21  
-s 指定将哪些内网网段进行映射转换  
-o 在那个网卡上NAT  
-j SNAT将源地址进行转换变更  
-j DNAT将目标地址进行转换变更  
--to-source 将源地址映射为什么IP地址  
--to-destination 将目标地址映射为什么IP地址
