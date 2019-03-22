Nginx七层反向代理负载均衡配置

http://nginx.org/en/docs/http/ngx_http_upstream_module.html \# 官网  
  
参考  
https://www.cnblogs.com/andyfengzp/p/6434125.html  
https://www.cnblogs.com/qq-361807535/p/6745484.html  
http://blog.51cto.com/13178102/2063271  
  
nginx 的安装和配置  
环境搭建  
Centos6.6 nginx-1.8.0.tar.gz  
  
nginx 负载均衡5种配置方式  
  
1、轮询（默认）  
每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。

2、weight  
指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。  
例如：  
upstream bakend {  
server 192.168.0.14 weight=10;  
server 192.168.0.15 weight=10;  
}

3、ip_hash  
每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。该调度算法可以解决动态网页的session共享问题，但有时会导致请求分配不均，即无法保证1:1的负载均衡，因为在国内大多数公司都是NAT上网模式，多个客户端会对应一个外部IP，所以，这些客户端都会被分配到同一节点服务器，从而导致请求分配不均。

LVS负载均衡的-p参数、Keepalived配置里的persistence_timeout
50参数都是类似这个Nginx里的ip_hash参数解决动态网页的session共享问题。  
例如：  
upstream bakend {  
ip_hash;  
server 192.168.0.14:88;  
server 192.168.0.15:80;  
}

4、fair（第三方）  
按后端服务器的响应时间来分配请求，响应时间短的优先分配。  
upstream backend {  
server server1;  
server server2;  
fair;  
}

5、url_hash（第三方）  
按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存时比较有效。  
例：在upstream中加入hash语句，server语句中不能写入weight等其他的参数，hash_method是使用的hash算法  
upstream backend {  
server squid1:3128;  
server squid2:3128;  
hash \$request_uri;  
hash_method crc32;  
}  
  
tips:  
  
upstream bakend{ \#定义负载均衡设备的Ip及设备状态  
ip_hash;  
server 127.0.0.1:9090 down;  
server 127.0.0.1:8080 weight=2;  
server 127.0.0.1:6060;  
server 127.0.0.1:7070 backup;  
}  
在需要使用负载均衡的server中增加  
proxy_pass http://bakend/;

每个设备的状态设置

1.down 表示单前的server暂时不参与负载  
2.weight 默认为1 weight越大，负载的权重就越大。  
3.max_fails 允许请求失败的次数默认为1.当超过最大次数时，返回proxy_next_upstream
模块定义的错误  
4.fail_timeout:max_fails次失败后，暂停的时间。  
5.backup
其它所有的非backup机器down或者忙的时候，请求backup机器。所以这台机器压力会最轻。  
\#  
nginx支持同时设置多组的负载均衡，用来给不用的server来使用。  
\#  
client_body_in_file_only 设置为On 可以讲client
post过来的数据记录到文件中用来做debug  
client_body_temp_path 设置记录文件的目录 可以设置最多3层目录  
\#  
location 对URL进行匹配.可以进行重定向或者进行新的代理 负载均衡

1、安装Nginx的依赖  
yum install gcc gcc-c++ autoconf automake zlib zlib-devel openssl openssl-devel
pcre pcre-devel -y  
参数分析：  
gcc环境【nginx编译使用】，zlib【压缩、解压】，pcer【使用perl库解析正则】  
openssl【安全套接字层密码库，主要的密码算法、常用的密钥和证书封装管理功能及SSL协议】  
  
2、下载Nginx  
wget http://nginx.org/download/nginx-1.8.0.tar.gz  
  
3、解压文件  
tar -xvf nginx-1.8.0.tar.gz  
  
4、进入nginx目录  
cd nginx-1.8.0  
  
5、配置Nginx编译参数  
(以下为同一行，不要回车换行，另外文中的文件夹比如/etc/nginx,/var/log/nginx需要执行前手动建好)  
./configure --prefix=/server/nginx --with-http_dav_module
--with-http_stub_status_module --with-http_addition_module
--with-http_sub_module --with-http_flv_module --with-http_mp4_module  
  
6、编译并安装  
make -j 2 && make install  
  
7、启动  
如果在第5步中指定了user与group，则需要创建该组与用户（未指定无需创建）  
groupadd -g 3001 nginx  
useradd -g 3001 -u 3001 -m nginx  
然后我们在安装目录/etc/nginx/sbin下启动  
/etc/nginx/sbin/nginx  
查看是否启动成功  
ps -ef\|grep -i nginx  
netstat -ntlp  
  
8、其他命令  
./nginx -c 指定配置文件  
./nginx -t 验证配置文件有无错误  
./nginx -s reload 重新加载配置文件  
./nginx -s quit 停止  
./nginx -s stop 强制停止  
./nginx -s quit && ./nginx 重启  
  
停止nginx  
然后进入安装后的配置文件目录cd /etc/nginx/conf  
备份nginx.conf  
cp nginx.conf nginx.conf.bak  
编辑配置文件  
vi nginx.conf  
\# 修改使用nginx账户  
user nginx nginx;  
\# 第一个：添加负载均衡后台地址  
  
\# 第一种：常规配置  
upstream web1 {  
server 192.168.21.10:80;  
server 192.168.21.11:80;  
}  
  
server {  
listen 80;  
server_name localhost;  
  
\#charset koi8-r;  
\#  
\#access_log logs/host.access.log main;  
  
location / {  
root html;  
index index.html index.htm;  
proxy_pass http://web1;  
}

\# 第二个：动静分离 location下加入if循环  
upstream htmls {  
server 192.168.21.10:80;  
server 192.168.21.11:80;  
}  
upstream phps {  
server 192.168.21.12:80;  
server 192.168.21.13:80;  
}  
upstream qitas {  
server 192.168.21.14:80;  
server 192.168.21.15:80;  
}  
  
server {  
listen 80;  
server_name localhost;  
  
\#charset koi8-r;  
  
\#access_log logs/host.access.log main;  
  
location / {  
root html;  
index index.html index.htm;  
if (\$request_uri \~\* \\.html\$){  
proxy_pass http://htmls;  
}  
if (\$request_uri \~\* \\.php\$){  
proxy_pass http://phps;  
}  
proxy_pass http://qitas;  
}  
  
关闭下面监听php的解析并测试 注意防火墙和selinux
