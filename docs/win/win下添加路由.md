在命令行下输入route命令，会有对应的提示信息。

ROUTE [-f] [-p] [-4\|-6] command [destination] [MASK netmask] [gateway] [METRIC
metric] [IF interface]  
-f 清除所有网关项的路由表。如果与某个  
命令结合使用，在运行该命令前，  
应清除路由表。  
-p 与 ADD 命令结合使用时，将路由设置为  
在系统引导期间保持不变。默认情况下，重新启动系统时，  
不保存路由。忽略所有其他命令，  
这始终会影响相应的永久路由。Windows 95  
不支持此选项。  
-4 强制使用 IPv4。  
-6 强制使用 IPv6。  
command 其中之一:  
PRINT 打印路由  
ADD 添加路由  
DELETE 删除路由  
CHANGE 修改现有路由  
destination 指定目的主机或者目的网段的网络地址。  
MASK 指定下一个参数为“网络掩码”值。  
netmask 指定此路由项的子网掩码值（目的主机或者目的网段的子网掩码）。  
如果未指定，其默认设置为 255.255.255.255。  
gateway 指定网关（下一跳）。  
interface 指定路由的接口号码。  
METRIC 指定跃点数，例如目标的成本。

实例：  
1、查看所有的路由表信息  
route print  
2、添加一条路由条目  
route add 157.0.0.0 MASK 255.0.0.0 157.55.80.1

roote add 10.41.226.5/32 10.0.76.254  
route add 157.0.0.0 MASK 255.0.0.0 157.55.80.1 METRIC 3  
route add 157.0.0.0 MASK 255.0.0.0 157.55.80.1 METRIC 3 IF 2  
3、添加一条永久路由条目（-p 表示永久路由，重启后不丢失）  
route -p add 157.0.0.0 MASK 255.0.0.0 157.55.80.1  
4、删除路由条目  
route delete 157.0.0.0  
5、修改路由条目（CHANGE 只用于修改网关和/或跃点数）  
route CHANGE 157.0.0.0 MASK 255.0.0.0 157.55.80.5 METRIC 2 IF 2
