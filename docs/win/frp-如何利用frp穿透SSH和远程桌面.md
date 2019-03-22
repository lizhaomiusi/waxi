如何利用frp穿透SSH和远程桌面？  
服务端frps.ini配置  
  
[common]  
bind_addr = 0.0.0.0  
bind_port = 7000  
token = www.nat.ee  
客户端frpc.ini配置  
  
[common]  
server_addr = 服务端IP  
server_port = 7000  
token = www.nat.ee  
  
[ssh]  
type = tcp  
local_port = 22  
remote_port = 10022  
local_ip = 127.0.0.1  
  
[desktop]  
type = tcp  
local_port = 3389  
remote_port = 10089  
local_ip = 127.0.0.1  
SSH端口默认为22，远程桌面端口默认为3389，而我们通过frp远程端口绑定到本地这两个端口，  
然后只需要访问 frps服务端IP:端口，既可访问我们要穿透的对应服务，  
上面的配置我用frps服务端的10022和10089远程端口，绑定穿透监听到本地frpc客户端的22和3389端口。  
当然，你可以使用除了10022和10089远程端口，其他frps服务端未被占用的1-65535任何端口，作为对应穿透服务端口。  
  
注意：这是最精简使用的方法实例，如你有更多要求，请参考详细参数阅读，而进行编写过。
