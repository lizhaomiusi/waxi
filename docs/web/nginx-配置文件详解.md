Nginx配置文件nginx.conf详解

Nginx 总的 配置文件 位置 /usr/local/nginx/conf/nginx.conf

nginx 正则匹配

一．正则表达式匹配，其中：

\~ 为区分大小写匹配

\~\* 为不区分大小写匹配

!\~和!\~\*分别为区分大小写不匹配及不区分大小写不匹配

二．文件及目录匹配，其中：

\-f和!-f用来判断是否存在文件

\-d和!-d用来判断是否存在目录

\-e和!-e用来判断是否存在文件或目录

\-x和!-x用来判断文件是否可执行

三．rewrite指令的最后一项参数为flag标记，flag标记有：

last 相当于apache里面的[L]标记，表示rewrite。

break本条规则匹配完成后，终止匹配，不再匹配后面的规则。

redirect 返回302临时重定向，浏览器地址会显示跳转后的URL地址。

permanent 返回301永久重定向，浏览器地址会显示跳转后的URL地址。

使用last和break实现URI重写，浏览器地址栏不变。

使用alias指令必须用last标记;

使用proxy_pass指令时，需要使用break标记。

Last标记在本条rewrite规则执行完毕后，会对其所在server{......}标签重新发起请求

break标记则在本条规则匹配完成后，终止匹配。

四．NginxRewrite 规则相关指令

　　1.break指令

　　　　使用环境：server,location,if;

　　　　该指令的作用是完成当前的规则集，不再处理rewrite指令。

　　2.if指令

　　　　使用环境：server,location

　　　　该指令用于检查一个条件是否符合，如果条件符合，则执行大括号内的语句。If指令不支持嵌套，不支持多个条件&&和\|\|处理。

3.return指令

　　语法：return code ;

　　使用环境：server,location,if;

　　该指令用于结束规则的执行并返回状态码给客户端。

　　示例：如果访问的URL以".sh"或".bash"结尾，则返回403状态码

　　location \~ .\*\\.(sh\|bash)?\$

　　{

　　　　return 403;

　　}

4.rewrite 指令

　　语法：rewriteregex replacement flag

　　使用环境：server,location,if

　　该指令根据表达式来重定向URI，或者修改字符串。指令根据配置文件中的顺序来执行。注意重写表达式只对相对路径有效。如果你想配对主机名，你应该使用if语句，示例如下：

　　if ( \$host \~\* www\\.(.\*) )

　　{

　　　　set \$host_without_www \$1;

　　　　rewrite \^(.\*)\$ http://\$host_without_www\$1 permanent;

　　}

5.Set指令

　　语法：setvariable value ; 默认值:none; 使用环境：server,location,if;

　　该指令用于定义一个变量，并给变量赋值。变量的值可以为文本、变量以及文本变量的联合。

　　示例：set \$varname "hello world";

6.Uninitialized_variable_warn指令

　　语法：uninitialized_variable_warnon\|off

　　使用环境：http,server,location,if

　　该指令用于开启和关闭未初始化变量的警告信息，默认值为开启。

五．Nginx的Rewrite规则编写实例

　　1.当访问的文件和目录不存在时，重定向到某个php文件

　　　　if ( !-e \$request_filename )

　　　　{

　　　　　　rewrite \^/(.\*)\$ index.php last;

　　　　}

　　2.目录对换 /123456/xxxx ====\> /xxxx?id=123456

　　　　rewrite \^/(\\d+)/(.+)/ /\$2?id=\$1 last;

　　3.如果客户端使用的是IE浏览器，则重定向到/ie目录下

　　　　if( \$http_user_agent \~ MSIE)

　　　　{

　　　　　　rewrite \^(.\*)\$ /ie/\$1 break;

　　　　}

　　4.禁止访问多个目录

　　　　location \~ \^/(cron\|templates)/

　　　　{

　　　　　　deny all;

　　　　　　break;

　　　　}

　　5.禁止访问以/data开头的文件

　　　　location \~ \^/data

　　　　{

　　　　　　deny all;

　　　　}

　　6.禁止访问以.sh,.flv,.mp3为文件后缀名的文件

　　　　location \~ .\*\\.(sh\|flv\|mp3)\$

　　　　{

　　　　　　return 403;

　　　　}

　　7.设置某些类型文件的浏览器缓存时间

　　　　location \~ .\*\\.(gif\|jpg\|jpeg\|png\|bmp\|swf)\$

　　　　{

　　　　　　expires 30d;

　　　　}

　　　　location \~ .\*\\.(js\|css)\$

　　　　{

　　　　　　expires 1h;

　　　　}

8.给favicon.ico和robots.txt设置过期时间;

　　这里为favicon.ico为99天,robots.txt为7天并不记录404错误日志

　　location \~(favicon.ico)

　　{

　　　　log_not_found off;

　　　　expires 99d;

　　　　break;

　　}

　　location \~(robots.txt)

　　{

　　　　log_not_found off;

　　　　expires 7d;

　　　　break;

　　}

9.设定某个文件的过期时间;这里为600秒，并不记录访问日志

　　location \^\~ /html/scripts/loadhead_1.js

　　{

　　　　access_log off;

　　　　root /opt/lampp/htdocs/web;

　　　　expires 600;

　　　　break;

　　}

10.文件反盗链并设置过期时间

　　这里的return412 为自定义的http状态码，默认为403，方便找出正确的盗链的请求

　　“rewrite \^/ http://img.linuxidc.net/leech.gif;” 显示一张防盗链图片

　　“access_log off;” 不记录访问日志，减轻压力

　　“expires 3d” 所有文件3天的浏览器缓存

　　location \~\*\^.+\\.(jpg\|jpeg\|gif\|png\|swf\|rar\|zip\|css\|js)\$

　　{

　　　　valid_referers none blocked \*.linuxidc.com\*.linuxidc.net localhost
208.97.167.194;

　　　　if (\$invalid_referer)

　　　　{

　　　　　　rewrite \^/ http://img.linuxidc.net/leech.gif;

　　　　　　return 412;

　　　　　　break;

　　　　}

　　　　access_log off;

　　　　root /opt/lampp/htdocs/web;

　　　　expires 3d;

　　　　break;

　　}

11.只允许固定ip访问网站，并加上密码

　　root /opt/htdocs/www;

　　allow 208.97.167.194;

　　allow 222.33.1.2;

　　allow 231.152.49.4;

　　deny all;

　　auth_basic “C1G_ADMIN”;

　　auth_basic_user_file htpasswd;

12将多级目录下的文件转成一个文件，增强seo效果

　　/job-123-456-789.html 指向/job/123/456/789.html

　　rewrite \^/job-([0-9]+)-([0-9]+)-([0-9]+)\\.html\$
/job/\$1/\$2/jobshow_\$3.html last;

13.文件和目录不存在的时候重定向：

　　if (!-e \$request_filename)

　　 {

　　　　proxy_pass http://127.0.0.1;

　　}

14.将根目录下某个文件夹指向2级目录

　　如/shanghaijob/ 指向 /area/shanghai/

　　如果你将last改成permanent，那么浏览器地址栏显是/location/shanghai/

　　rewrite \^/([0-9a-z]+)job/(.\*)\$ /area/\$1/\$2last;

　　上面例子有个问题是访问/shanghai时将不会匹配

　　rewrite \^/([0-9a-z]+)job\$ /area/\$1/ last;

　　rewrite \^/([0-9a-z]+)job/(.\*)\$ /area/\$1/\$2last;

　　这样/shanghai 也可以访问了，但页面中的相对链接无法使用，

　　如./list_1.html真实地址是/area/shanghia/list_1.html会变成/list_1.html,导至无法访问。

　　那我加上自动跳转也是不行咯

　　(-d
\$request_filename)它有个条件是必需为真实目录，而我的rewrite不是的，所以没有效果

　　if (-d \$request_filename)

　　{

　　　　rewrite \^/(.\*)([\^/])\$ http://\$host/\$1\$2/permanent;

　　}

　　知道原因后就好办了，让我手动跳转吧

　　rewrite \^/([0-9a-z]+)job\$ /\$1job/permanent;

　　rewrite \^/([0-9a-z]+)job/(.\*)\$ /area/\$1/\$2last;

15.域名跳转

　　server

　　{

　　　　listen 80;

　　　　server_name jump.linuxidc.com;

　　　　index index.html index.htm index.php;

　　　　root /opt/lampp/htdocs/www;

　　　　rewrite \^/ http://www.linuxidc.com/;

　　　　access_log off;

　　}

16.多域名转向

　　server_name www.linuxidc.com www.linuxidc.net;

　　index index.html index.htm index.php;

　　root /opt/lampp/htdocs;

　　if (\$host \~ "linuxidc\\.net") {

　　　　rewrite \^(.\*) http://www.linuxidc.com\$1permanent;

　　}

六．nginx全局变量

arg_PARAMETER \#这个变量包含GET请求中，如果有变量PARAMETER时的值。

args \#这个变量等于请求行中(GET请求)的参数，如：foo=123\&bar=blahblah;

binary_remote_addr \#二进制的客户地址。

body_bytes_sent \#响应时送出的body字节数数量。即使连接中断，这个数据也是精确的。

content_length \#请求头中的Content-length字段。

content_type \#请求头中的Content-Type字段。

cookie_COOKIE \#cookie COOKIE变量的值

document_root \#当前请求在root指令中指定的值。

document_uri \#与uri相同。

host \#请求主机头字段，否则为服务器名称。

hostname \#Set to themachine’s hostname as returned by gethostname

http_HEADER

is_args \#如果有args参数，这个变量等于”?”，否则等于”"，空值。

http_user_agent \#客户端agent信息

http_cookie \#客户端cookie信息

limit_rate \#这个变量可以限制连接速率。

query_string \#与args相同。

request_body_file \#客户端请求主体信息的临时文件名。

request_method \#客户端请求的动作，通常为GET或POST。

remote_addr \#客户端的IP地址。

remote_port \#客户端的端口。

remote_user \#已经经过Auth Basic Module验证的用户名。

request_completion \#如果请求结束，设置为OK.
当请求未结束或如果该请求不是请求链串的最后一个时，为空(Empty)。

request_method \#GET或POST

request_filename \#当前请求的文件路径，由root或alias指令与URI请求生成。

request_uri
\#包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。不能修改。

scheme \#HTTP方法（如http，https）。

server_protocol \#请求使用的协议，通常是HTTP/1.0或HTTP/1.1。

server_addr \#服务器地址，在完成一次系统调用后可以确定这个值。

server_name \#服务器名称。

server_port \#请求到达服务器的端口号。

七．Apache和Nginx规则的对应关系

Apache的RewriteCond对应Nginx的if

Apache的RewriteRule对应Nginx的rewrite

Apache的[R]对应Nginx的redirect

Apache的[P]对应Nginx的last

Apache的[R,L]对应Nginx的redirect

Apache的[P,L]对应Nginx的last

Apache的[PT,L]对应Nginx的last

例如：允许指定的域名访问本站，其他的域名一律转向www.linuxidc.net

Apache:

RewriteCond %{HTTP_HOST} !\^(.\*?)\\.aaa\\.com\$[NC]

RewriteCond %{HTTP_HOST} !\^localhost\$

RewriteCond %{HTTP_HOST}!\^192\\.168\\.0\\.(.\*?)\$

RewriteRule \^/(.\*)\$ http://www.linuxidc.net[R,L]

Nginx:

if( \$host \~\* \^(.\*)\\.aaa\\.com\$ )

{

　　set \$allowHost '1';

}

if( \$host \~\* \^localhost )

{

　　set \$allowHost '1';

}

if( \$host \~\* \^192\\.168\\.1\\.(.\*?)\$ )

{

　　set \$allowHost '1';

}

if( \$allowHost !\~ '1' )

{

　　rewrite \^/(.\*)\$ http://www.linuxidc.netredirect ;

}

\----------------------------------------------------------------------------------

nginx conf 配置文件

nginx进程数，建议设置为等于CPU总核心数.

worker_processes 8;

全局错误日志定义类型，[ debug \| info \| notice \| warn \| error \| crit ]

error_log /var/log/nginx/error.log info;

进程文件

pid /var/run/nginx.pid;

一个nginx进程打开的最多文件描述符数目，理论值应该是最多打开文件数（系统的值ulimit
-n）与nginx进程数相除，但是nginx分配请求并不均匀，所以建议与ulimit
-n的值保持一致。

worker_rlimit_nofile 65535;

工作模式与连接数上限

events

{

　　\#参考事件模型，use [ kqueue \| rtsig \| epoll \| /dev/poll \| select \|
poll ]; epoll模型是Linux
2.6以上版本内核中的高性能网络I/O模型，如果跑在FreeBSD上面，就用kqueue模型。

　　use epoll;

　　\#单个进程最大连接数（最大连接数=连接数\*进程数）

　　worker_connections 65535;

}

设定http服务器

http

{

include mime.types; \#文件扩展名与文件类型映射表

default_type application/octet-stream; \#默认文件类型

\#charset utf-8; \#默认编码

server_names_hash_bucket_size 128; \#服务器名字的hash表大小

client_header_buffer_size 32k; \#上传文件大小限制

large_client_header_buffers 4 64k; \#设定请求缓

client_max_body_size 8m; \#设定请求缓

sendfile on;
\#开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，对于普通应用设为
on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成off。

autoindex on; \#开启目录列表访问，合适下载服务器，默认关闭。

tcp_nopush on; \#防止网络阻塞

tcp_nodelay on; \#防止网络阻塞

keepalive_timeout 120; \#长连接超时时间，单位是秒

\#FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。

fastcgi_connect_timeout 300;

fastcgi_send_timeout 300;

fastcgi_read_timeout 300;

fastcgi_buffer_size 64k;

fastcgi_buffers 4 64k;

fastcgi_busy_buffers_size 128k;

fastcgi_temp_file_write_size 128k;

\#gzip模块设置

gzip on; \#开启gzip压缩输出

gzip_min_length 1k; \#最小压缩文件大小

gzip_buffers 4 16k; \#压缩缓冲区

gzip_http_version 1.0; \#压缩版本（默认1.1，前端如果是squid2.5请使用1.0）

gzip_comp_level 2; \#压缩等级

gzip_types text/plain application/x-javascript text/css application/xml;

\#压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。

gzip_vary on;

\#limit_zone crawler \$binary_remote_addr 10m; \#开启限制IP连接数的时候需要使用

upstream blog.ha97.com {

\#upstream的负载均衡，weight是权重，可以根据机器配置定义权重。weigth参数表示权值，权值越高被分配到的几率越大。

server 192.168.80.121:80 weight=3;

server 192.168.80.122:80 weight=2;

server 192.168.80.123:80 weight=3;

}

虚拟主机的配置

server

{

listen 80;　　　　\#监听端口

　　　　server_name aa.cn www.aa.cn ; \#server_name end
\#域名可以有多个，用空格隔开

index index.html index.htm index.php; \# 设置访问主页

　　　　set \$subdomain ''; \# 绑定目录为二级域名 bbb.aa.com 根目录 /bbb 文件夹

　　　　if ( \$host \~\*
"(?:(\\w+\\.){0,})(\\b(?!www\\b)\\w+)\\.\\b(?!(com\|org\|gov\|net\|cn)\\b)\\w+\\.[a-zA-Z]+"
) { set \$subdomain "/\$2"; }

root /home/wwwroot/aa.cn/web\$subdomain;\# 访问域名跟目录

include rewrite/dedecms.conf; \#rewrite end \#载入其他配置文件

location \~ .\*.(php\|php5)?\$

{

　　fastcgi_pass 127.0.0.1:9000;

　　fastcgi_index index.php;

　　include fastcgi.conf;

}

\#图片缓存时间设置

location \~ .\*.(gif\|jpg\|jpeg\|png\|bmp\|swf)\$

{

　　expires 10d;

}

\#JS和CSS缓存时间设置

location \~ .\*.(js\|css)?\$

{

　　expires 1h;

}

}

日志格式设定

log_format access '\$remote_addr - \$remote_user [\$time_local] "\$request" '

'\$status \$body_bytes_sent "\$http_referer" '

'"\$http_user_agent" \$http_x_forwarded_for';

\#定义本虚拟主机的访问日志

access_log /var/log/nginx/ha97access.log access;

\#对 "/" 启用反向代理

location / {

proxy_pass http://127.0.0.1:88;

proxy_redirect off;

proxy_set_header X-Real-IP \$remote_addr;

\#后端的Web服务器可以通过X-Forwarded-For获取用户真实IP

proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

\#以下是一些反向代理的配置，可选。

proxy_set_header Host \$host;

client_max_body_size 10m; \#允许客户端请求的最大单文件字节数

client_body_buffer_size 128k; \#缓冲区代理缓冲用户端请求的最大字节数，

proxy_connect_timeout 90; \#nginx跟后端服务器连接超时时间(代理连接超时)

proxy_send_timeout 90; \#后端服务器数据回传时间(代理发送超时)

proxy_read_timeout 90; \#连接成功后，后端服务器响应时间(代理接收超时)

proxy_buffer_size 4k; \#设置代理服务器（nginx）保存用户头信息的缓冲区大小

proxy_buffers 4 32k; \#proxy_buffers缓冲区，网页平均在32k以下的设置

proxy_busy_buffers_size 64k; \#高负荷下缓冲大小（proxy_buffers\*2）

proxy_temp_file_write_size 64k;

\#设定缓存文件夹大小，大于这个值，将从upstream服务器传

}

设定查看Nginx状态的地址

location /NginxStatus {

stub_status on;

access_log on;

auth_basic "NginxStatus";

auth_basic_user_file conf/htpasswd;

\#htpasswd文件的内容可以用apache提供的htpasswd工具来产生。

}

\#本地动静分离反向代理配置

\#所有jsp的页面均交由tomcat或resin处理

location \~ .(jsp\|jspx\|do)?\$ {

proxy_set_header Host \$host;

proxy_set_header X-Real-IP \$remote_addr;

proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

proxy_pass http://127.0.0.1:8080;

}

\#所有静态文件由nginx直接读取不经过tomcat或resin

location \~
.\*.(htm\|html\|gif\|jpg\|jpeg\|png\|bmp\|swf\|ioc\|rar\|zip\|txt\|flv\|mid\|doc\|ppt\|pdf\|xls\|mp3\|wma)\$

{　　 expires 15d;　　 }

location \~ .\*.(js\|css)?\$

{ 　　expires 1h;　　 }

}

\---------------------------------------------------------------------

nginx 在thinkphp 的url 重写

在/usr/local/nginx/conf/vhost/你的域名配置文件 中添加

location / {

　　if (!-e \$request_filename) {

　　rewrite \^/(.\*)/(.\*)/(.\*)/\*\$ /index.php?m=\$1&c=\$2&a=\$3 last; \#
thinkphp 的配置文件中 'URL_MODEL' =\> 1 PATHINFO模式

\#或者 rewrite \^(.\*)\$ /index.php?s=\$1 last;　　　　 \# thinkphp 的配置文件中
'URL_MODEL' =\>3 兼容模式

\#或者 rewrite /(.\*)\$ /index.php/\$1 last; \# thinkphp 的配置文件中
'URL_MODEL' =\> 2 REWRITE模式

　　break;

　　}

}

//----------------------------------------------------------------------------------------------------------------------------------------

路径 pathinfo 模式[ thinkphp ] 添加

location \~ \\.php(.\*)\$ {

　　fastcgi_pass 127.0.0.1:9000;

　　fastcgi_index index.php;

　　fastcgi_split_path_info \^((?U).+\\.php)(/?.+)\$;

　　fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

　　fastcgi_param PATH_INFO \$fastcgi_path_info;

　　fastcgi_param PATH_TRANSLATED \$document_root\$fastcgi_path_info;

　　include fastcgi_params;

}

//----------------------------------------------------------------------------------------------------------------------------------------

重写 url +省略index.php

location / {

　　try_files \$uri /index.php?\$uri;

}

nginx -s reload 或者 /usr/local/nginx/sbin/nginx -s reload 重新加载Nginx配置文件

文章中的tp是 thinkphp 3.2.3 ，5.0 的未测试
