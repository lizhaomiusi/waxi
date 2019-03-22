frp-frps服务端ini各配置参数详解

[必须]标识头  
[common]  
是不可或缺的部分  
  
[必须]服务器IP  
bind_addr = 0.0.0.0  
0.0.0.0为服务器全局所有IP可用，假如你的服务器有多个IP则可以这样做，或者填写为指定其中的一个服务器IP,支持IPV6.  
  
[必须]FRP通讯端口  
bind_port = 7000  
用于和客户端内网穿透传输数据的端口，可自定义。  
  
用于KCP协议UDP通讯端口  
kcp_bind_port = 7000  
也可以和“bind_port”共用同一端口，如果没有设置，则kcp在frps中被禁用，可自定义。  
  
UDP通讯端口  
bind_udp_port = 7001  
以帮助使UDP打洞穿透NAT，可自定义。  
  
[必须]连接认证密钥-特权模式  
token = www.nat.ee  
客户端连接到本服务端的登录验证密钥，可自定义。  
  
如果你想支持http，必须指定http端口监听  
vhost_http_port = 80  
指定端口为http网页协议，可自定义。  
  
如果你想支持https，必须指定https端口监听  
vhost_https_port = 443  
指定端口为https网页协议，可自定义。  
  
限制只能使用服务端的指定端口  
allow_ports = 2000-3000,3001,3003,4000-50000  
只允许客户端绑定你列出的端口，如果你什么都不设置的话，不会有任何限制。可自定义！  
开放这些端口，给客户端使用，包括tcp、udp、kcp、  
  
自定义二级域名  
subdomain_host = frps.com  
通过在 frps 的配置文件中配置 subdomain_host，就可以启用该特性。之后在 frpc 的
http、https 类型的代理中可以不配置 custom_domains，而是配置一个 subdomain 参数。  
只需要将 \*.{subdomain_host} 解析到 frps 所在服务器。之后用户可以通过 subdomain
自行指定自己的 web 服务所需要使用的二级域名，通过 {subdomain}.{subdomain_host}
来访问自己的 web 服务。  
  
每个内网穿透服务限制最大连接池上限  
max_pool_count = 5  
每个内网穿透可以创建的连接池上限，避免大量资源占用。可自定义。  
  
客户端最大可用端口，tcp/udp远程端口  
max_ports_per_client = 0  
最大端口可用于每个客户端，默认值为0表示无限制。  
  
如果使用tcp流复用，默认值为true  
tcp_mux=true  
不开启则，false  
客户端和服务器端之间的连接支持多路复用，不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使
frp 可以承载更高的并发数。  
  
心跳配置，不建议修改，默认值是90  
heartbeat_timeout = 90  
可自定义。  
  
客户端与服务端时间相差验证  
authentication_timeout = 900  
假如客户端设备的时间和服务端的时间相差大于设定值，那么拒绝客户端连接。  
如果设置为0，则不验证时间，默认值为900秒，可自定义。  
  
通过浏览器查看 frp 的状态以及代理统计信息展示。  
绑定服务端IP  
dashboard_addr = 0.0.0.0  
0.0.0.0为服务器全局所有IP可用，假如你的服务器有多个IP则可以这样做，或者填写为指定其中的一个服务器IP,支持IPV6.  
  
WEB端口  
dashboard_port = 7500  
访问WEB服务端IP:端口，可自定义。  
  
用户名  
dashboard_user = admin  
自定义WEB管理用户名，如果没有设置，默认值是admin。  
  
登录密码  
dashboard_pwd = admin  
自定义WEB管理密码，如果没有设置，默认值是admin。  
  
记录日志  
  
日志存放路径  
log_file = /etc/frp/log/frps.log  
  
日志记录类别  
log_level = info  
可选：trace, debug, info, warn, error  
  
最多保存多少天日志  
log_max_days = 7  
可自定义保存多少天。
