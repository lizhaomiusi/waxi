linux下添加路由

linux 下静态路由修改命令 方法一：  
添加路由  
route add -net 192.168.0.0/24 gw 192.168.0.1  
route add -host 192.168.1.1 dev 192.168.0.1  
删除路由  
route del -net 192.168.0.0/24 gw 192.168.0.1  
add 增加路由  
del 删除路由  
-net 设置到某个网段的路由  
-host 设置到某台主机的路由  
gw 出口网关 IP 地址 dev 出口网关物理设备名  
增加默认路由 route add default gw 192.168.0.1 默认路由一条就够了  
route -n 查看路由表

方法二： 添加路由  
ip route add 192.168.0.0/24 via 192.168.0.1  
ip route add 192.168.1.1 dev 192.168.0.1  
删除路由 ip route del 192.168.0.0/24 via 192.168.0.1  
add 增加路由  
del 删除路由  
via 网关出口  
IP 地址  
dev 网关出口物理设备名  
增加默认路由 ip route add default via 192.168.0.1 dev eth0 via 192.168.0.1  
是我的默认路由器 查看路由信息 ip route 保存路由设置，使其在网络重启后任然有效  
在/etc/sysconfig/network-script/目录下创建名为 route-eth0 的文件 vi
/etc/sysconfig/network-script/route-eth0
