HAProxy的安装与应用

http://www.178linux.com/76124  
https://www.cnblogs.com/Richardzhu/p/3344676.html  
https://www.jianshu.com/p/3b3a3e8dd0f5  
https://www.cnblogs.com/f-ck-need-u/p/8540805.html  
https://www.cnblogs.com/MacoLee/p/5853413.html  
  
Haproxy提供高可用性、负载均衡以及基于TCP和HTTP应用的代理，支持虚拟主机，它是免费、快速并且可靠的一种解决方案。Haproxy特别适用于那些负载特大的web站点，这些站点通常又需要会保持或七层处理。Haproxy运行在当前的硬件上，完全可以支持数以万计的并发连接。并且它的运行模式使得它可以很简单安全的整合进您当前的架构中，同时可以保护你的web服务器不被暴露到网络上。  
  
配置Haproxy  
Haproxy配置中分成五部分内容，当然这些组件不是必选的，可以根据需要选择作为配置。  
•global：参数是进程级的，通常和操作系统(OS)相关。这些参数一般只设置一次，如果配置无误，就不需要再次配置进行修改；  
•default：配置默认参数的，这些参数可以被利用配置到frontend，backend，listen组件；  
•frontend：接收请求的前端虚拟节点，Frontend可以根据规则直接指定具体使用后端的backend(可动态选择)；  
•backend：后端服务集群的配置，是真实的服务器，一个Backend对应一个或者多个实体服务器；  
•listen：Frontend和Backend的组合体。  
  
\# 配置文件  
/etc/haproxy/haproxy.cfg  
cat /etc/haproxy/haproxy.cfg

\#\#\#\#\#\#\#\#\#\#\#全局配置\#\#\#\#\#\#\#\#\#  
global  
　　log 127.0.0.1 local0 \#[日志输出配置，所有日志都记录在本机，通过local0输出]  
　　log 127.0.0.1 local1 notice \#定义haproxy 日志级别[error warringinfo debug]  
　　daemon \#以后台形式运行harpoxy  
　　nbproc 1 \#设置进程数量  
　　maxconn 4096 \#默认最大连接数,需考虑ulimit-n限制  
　　\#user haproxy \#运行haproxy的用户  
　　\#group haproxy \#运行haproxy的用户所在的组  
　　\#pidfile /var/run/haproxy.pid \#haproxy 进程PID文件  
　　\#ulimit-n 819200 \#ulimit 的数量限制  
　　\#chroot /usr/share/haproxy \#chroot运行路径  
　　\#debug \#haproxy 调试级别，建议只在开启单进程的时候调试  
　　\#quiet  
  
\#\#\#\#\#\#\#\#默认配置\#\#\#\#\#\#\#\#\#\#\#\#  
defaults  
　　log global  
　　mode http \#默认的模式mode { tcp\|http\|health
}，tcp是4层，http是7层，health只会返回OK  
　　option httplog \#日志类别,采用httplog  
　　option dontlognull \#不记录健康检查日志信息  
　　retries 2 \#两次连接失败就认为是服务器不可用，也可以通过后面设置  
　　\#option forwardfor
\#如果后端服务器需要获得客户端真实ip需要配置的参数，可以从Http
Header中获得客户端ip  
　　option httpclose
\#每次请求完毕后主动关闭http通道,haproxy不支持keep-alive,只能模拟这种模式的实现  
　　\#option redispatch
\#当serverId对应的服务器挂掉后，强制定向到其他健康的服务器，以后将不支持  
　　option abortonclose
\#当服务器负载很高的时候，自动结束掉当前队列处理比较久的链接  
　　maxconn 4096 \#默认的最大连接数  
　　timeout connect 5000ms \#连接超时  
　　timeout client 30000ms \#客户端超时  
　　timeout server 30000ms \#服务器超时  
　　\#timeout check 2000 \#心跳检测超时  
　　\#timeout http-keep-alive10s \#默认持久连接超时时间  
　　\#timeout http-request 10s \#默认http请求超时时间  
　　\#timeout queue 1m \#默认队列超时时间  
　　balance roundrobin \#设置默认负载均衡方式，轮询方式  
　　\#balance source \#设置默认负载均衡方式，类似于nginx的ip_hash  
　　\#balnace leastconn \#设置默认负载均衡方式，最小连接数  
  
\#\#\#\#\#\#\#\#统计页面配置\#\#\#\#\#\#\#\#  
listen stats  
　　bind 0.0.0.0:1080
\#设置Frontend和Backend的组合体，监控组的名称，按需要自定义名称  
　　mode http \#http的7层模式  
　　option httplog \#采用http日志格式  
　　\#log 127.0.0.1 local0 err \#错误日志记录  
　　maxconn 10 \#默认的最大连接数  
　　stats refresh 30s \#统计页面自动刷新时间  
　　stats uri /stats \#统计页面url  
　　stats realm XingCloud\\ Haproxy \#统计页面密码框上提示文本  
　　stats auth admin:admin \#设置监控页面的用户和密码:admin,可以设置多个用户名  
　　stats auth Frank:Frank \#设置监控页面的用户和密码：Frank  
　　stats hide-version \#隐藏统计页面上HAProxy的版本信息  
　　stats admin if TRUE \#设置手工启动/禁用，后端服务器(haproxy-1.4.9以后版本)  
  
\#\#\#\#\#\#\#\#设置haproxy 错误页面\#\#\#\#\#  
\#errorfile 403 /home/haproxy/haproxy/errorfiles/403.http  
\#errorfile 500 /home/haproxy/haproxy/errorfiles/500.http  
\#errorfile 502 /home/haproxy/haproxy/errorfiles/502.http  
\#errorfile 503 /home/haproxy/haproxy/errorfiles/503.http  
\#errorfile 504 /home/haproxy/haproxy/errorfiles/504.http  
  
\#\#\#\#\#\#\#\#frontend前端配置\#\#\#\#\#\#\#\#\#\#\#\#\#\#  
frontend main  
　　bind \*:80 \#这里建议使用bind
\*:80的方式，要不然做集群高可用的时候有问题，vip切换到其他机器就不能访问了。  
　　acl web hdr(host) -i www.abc.com
\#acl后面是规则名称，-i为忽略大小写，后面跟的是要访问的域名，如果访问www.abc.com这个域名，就触发web规则，。  
　　acl img hdr(host) -i img.abc.com
\#如果访问img.abc.com这个域名，就触发img规则。  
　　use_backend webserver if web
\#如果上面定义的web规则被触发，即访问www.abc.com，就将请求分发到webserver这个作用域。  
　　use_backend imgserver if img
\#如果上面定义的img规则被触发，即访问img.abc.com，就将请求分发到imgserver这个作用域。  
　　default_backend dynamic \#不满足则响应backend的默认页面  
  
\#\#\#\#\#\#\#\#backend后端配置\#\#\#\#\#\#\#\#\#\#\#\#\#\#  
backend webserver \#webserver作用域  
　　mode http  
　　balance roundrobin \#balance roundrobin 负载轮询，balance source
保存session值，支持static-rr，leastconn，first，uri等参数  
　　option httpchk /index.html HTTP/1.0 \#健康检查,
检测文件，如果分发到后台index.html访问不到就不再分发给它  
　　server web1 10.16.0.9:8085 cookie 1 weight 5 check inter 2000 rise 2 fall 3  
　　server web2 10.16.0.10:8085 cookie 2 weight 3 check inter 2000 rise 2 fall 3  
　　\#cookie 1表示serverid为1，check inter 1500 是检测心跳频率  
　　\#rise 2是2次正确认为服务器可用，fall
3是3次失败认为服务器不可用，weight代表权重  
  
backend imgserver  
　　mode http  
　　option httpchk /index.php  
　　balance roundrobin  
　　server img01 192.168.137.101:80 check inter 2000 fall 3  
　　server img02 192.168.137.102:80 check inter 2000 fall 3  
  
backend dynamic  
　　balance roundrobin  
　　server test1 192.168.1.23:80 check maxconn 2000  
　　server test2 192.168.1.24:80 check maxconn 2000  
  
listen tcptest  
　　bind 0.0.0.0:5222  
　　mode tcp  
　　option tcplog \#采用tcp日志格式  
　　balance source  
　　\#log 127.0.0.1 local0 debug  
　　server s1 192.168.100.204:7222 weight 1  
　　server s2 192.168.100.208:7222 weight 1

\# 说明一下实验环境配置:  
HAS0=10.1.2.13  
RS1=10.1.2.14  
RS2=10.1.2.15  
  
\# 在配置之前要用ntpdate命令对3台机子进行时间同步.  
yum -y install ntp  
ntpdate ntp1.aliyun.com  
  
\# 在RS上安装web服务:  
\# 在两台真实的web服务机器上安装httpd或者nginx  
yum -y install httpd  
  
\# 配置web服务的主页:  
\#14主机上:  
echo 14 \> /var/www/html/index.html  
\#15主机上:  
echo 15 \> /var/www/html/index.html  
/etc/init.d/httpd restart  
测试，注意防火墙  
  
\# 在haproxy服务器端安装:  
yum -y install haproxy  
  
\# 查询并配置:  
rpm -ql haproxy  
  
\# 配置haproxy服务：  
在 /etc/haproxy/haproxy.cfg注释掉默认的代理配置并添加如下的配置.  
vim /etc/haproxy/haproxy.cfg  
  
frontend testweb \#定义名称为 testweb 的frontend  
bind \*:80 \#监听所有地址的web服务80端口  
default_backend mywebs \#定义名称为mywebs的backend后端web服务  
  
backend mywebs \#定义名称为mywebs的backend  
balance roundrobin \#定义负载均衡算法  
server srv1 10.1.2.13:80 check  
server srv2 10.1.2.13:80 check  
\#定义server  
\# srv1: server的id名称  
\#check:进行健康检测  
  
\#简单的配置  
\#启动haproxy并检验:  
chkconfig haproxy on  
/etc/init.d/haproxy restart  
  
--------------分割线--------------  
  
在客户端上实验  
for i in {1..10}; do curl http://10.1.2.13:5000; done  
\#  
到这里就完成了一个简单的haproxy服务的配置.
