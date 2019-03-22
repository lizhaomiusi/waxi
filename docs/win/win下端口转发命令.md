win下端口转发命令  
  
https://www.cnblogs.com/diligenceday/p/6919880.html  
  
其实Windows本身命令行支持配置端口映射，条件是已经安装了IPV6，启不启用都无所谓，我在win7和server2008上是可以的。xp，2003装了ipv6协议也是可以的。  
  
使用Portproxy模式下的Netsh命令即能实现Windows系统中的端口转发，转发命令如下  
  
CMD下操作  
  
增加端口映射，将192.168.10.1的11111映射到192.168.10.2的80端口  
netsh interface portproxy add v4tov4 listenport=11111 listenaddress=127.0.0.1
connectport=80 connectaddress=127.0.0.1  
  
解释一下这其中的参数意义  
listenaddress -- 等待连接的本地ip地址  
listenport -- 本地监听的TCP端口（待转发）  
connectaddress -- 被转发端口的本地或者远程主机的ip地址  
connectport -- 被转发的端口  
add - 在一个表格中添加一个配置项。  
delete - 从一个表格中删除一个配置项。  
dump - 显示一个配置脚本。  
help - 显示命令列表。  
reset - 重置端口代理配置状态。  
set - 设置配置信息。  
show - 显示信息。  
  
删除端口映射  
netsh interface portproxy del v4tov4 listenport=90 listenaddress=127.0.0.1  
  
查看已存在的端口映射  
netsh interface portproxy show v4tov4  
  
如果想要清空当前所有的配置规则，命令如下：  
netsh interface portproxy reset  
  
可以通过命令 netstat -ano\|find “90” 查看端口是否已在监听  
  
telnet 127.0.0.1 90 测试端口是否连通  
  
注意：  
如果这条命令没有返回任何信息，或者说通过netsh接口并没有实现端口转发的功能，那么需要查看下系统是否开启了iphlpsvc（ip
Helper）服务。  
并且需要在网络配置中查看端口转发规则是否被创建、IPv6的支持是否开启。
