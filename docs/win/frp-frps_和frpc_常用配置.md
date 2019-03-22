frp-frps 和frpc 常用配置  
frps.ini  
[common]  
bind_addr = 0.0.0.0  
bind_port = 7000  
kcp_bind_port = 7000  
bind_udp_port = 7001  
token = aaa\@111  
vhost_http_port = 80  
vhost_https_port = 443  
allow_ports = 10001-10005  
\#subdomain_host = nat.ee  
max_pool_count = 6  
max_ports_per_client = 3  
tcp_mux=true  
heartbeat_timeout = 90  
authentication_timeout = 900  
\#[admin]  
dashboard_addr = 0.0.0.0  
dashboard_port = 7500  
dashboard_user = admin  
dashboard_pwd = admin  
\#[log]  
log_file = ./frps.log  
log_level = info  
log_max_days = 7  
  
  
frpc.ini  
[common]  
server_addr = 139.199.87.197  
server_port = 7000  
token = aaa\@123  
log_file = ./frpc.log  
  
[desktop]  
type = tcp  
local_port = 3389  
remote_port = 10089  
local_ip = 127.0.0.1  
  
[web]  
type = tcp  
local_port = 80  
remote_port = 10088  
local_ip = 127.0.0.1
