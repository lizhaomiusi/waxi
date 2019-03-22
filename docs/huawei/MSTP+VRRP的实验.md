MSTP+VRRP的实验

![](media/83c12577e44a27873f180945843d74e3.png)

二、实验简介  
规划地址 vlan 接口 并连接  
查找根交换机，确定主根和备根交换位置  
创建链路聚合  
创建vrrp协议，虚拟地址  
  
优化  
vrrp协议中 追踪上行链路的可达性，在核心交换下配置  
  
四、具体配置如下  
1、S5700_Master的配置

[master]dis cu  
vlan batch 10 20 100  
\#  
stp instance 0 root primary  
\#  
interface Vlanif10  
ip address 10.1.10.1 255.255.255.0  
vrrp vrid 10 virtual-ip 10.1.10.254  
vrrp vrid 10 priority 120  
vrrp vrid 10 preempt-mode timer delay 5  
vrrp vrid 10 track interface GigabitEthernet0/0/24 reduced 50  
\#  
interface Vlanif20  
ip address 10.1.20.1 255.255.255.0  
vrrp vrid 20 virtual-ip 10.1.20.254  
vrrp vrid 20 priority 120  
vrrp vrid 20 preempt-mode timer delay 5  
\#  
interface Vlanif100  
ip address 10.1.100.1 255.255.255.0  
\#  
interface Eth-Trunk1  
port link-type trunk  
port trunk allow-pass vlan 100  
\#  
interface GigabitEthernet0/0/1  
eth-trunk 1  
\#  
interface GigabitEthernet0/0/2  
eth-trunk 1  
\#  
interface GigabitEthernet0/0/3  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#  
interface GigabitEthernet0/0/4  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#

\---

2、S5700_Backup的配置

[backup]dis cu  
\#  
vlan batch 10 20 100  
\#  
stp instance 0 root secondary  
\#  
interface Vlanif10  
ip address 10.1.10.2 255.255.255.0  
vrrp vrid 10 virtual-ip 10.1.10.254  
\#  
interface Vlanif20  
ip address 10.1.20.2 255.255.255.0  
vrrp vrid 20 virtual-ip 10.1.20.254  
vrrp vrid 20 track interface GigabitEthernet0/0/24 reduced 50  
\#  
interface Vlanif100  
ip address 10.1.100.2 255.255.255.0  
\#  
interface Eth-Trunk1  
port link-type trunk  
port trunk allow-pass vlan 100  
\#  
interface GigabitEthernet0/0/1  
eth-trunk 1  
\#  
interface GigabitEthernet0/0/2  
eth-trunk 1  
\#  
interface GigabitEthernet0/0/3  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#  
interface GigabitEthernet0/0/4  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#

\---

3、sw3的配置  
[sw3]dis cu  
\#  
vlan batch 10 20  
\#  
interface Ethernet0/0/1  
port link-type access  
port default vlan 10  
\#  
interface Ethernet0/0/3  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#  
interface Ethernet0/0/4  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#

\---

4、sw4的配置如下  
[sw4]dis cu  
\#  
vlan batch 10 20  
\#  
interface Ethernet0/0/1  
port link-type access  
port default vlan 20  
\#  
interface Ethernet0/0/3  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#  
interface Ethernet0/0/4  
port link-type trunk  
port trunk allow-pass vlan 10 20  
\#

现在来验证PC端
