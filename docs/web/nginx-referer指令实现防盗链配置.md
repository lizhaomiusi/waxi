nginx-referer指令实现防盗链配置

处于服务性能的考虑，我们通常把HTML静态资源按照不同类型划分存放在多台服务上。

![](media/ac1da0187e914a3a41bf64c9388b11a1.png)

超文本传输协议中的Referer作用

Referer：null 表示请求者直接访问

Referer：blocked 一般为防火墙设备添加的

Referer：URL 表示URL中的主机告诉请求者的间接访问

图中jpg.good.com显然是一台专门用户存放图片的服务器，而www.good.com是一台WEB服务器，从域名可以看出必然是一家公司，条件：

1、只允许访问www.good.com的用户以链接的身份访问jpg.good.com（Referer：URL中Host内容为www.good.com）

2、拒绝Referer：null（表示请求者直接访问）拒绝。

3、防止盗链接（拒绝用户以链接的身份访问jpg.good.com
；Referer：URL中Host内容不是www.good.com）

实现图片防盗链：

location \~\* .(gif\|jpg\|png\|webp)\$ {

valid_referers none blocked domain.com \*.domain.com server_names \~.google.
\~.baidu.;

if (\$invalid_referer) {

return 403;

\#rewrite \^/ http://www.domain.com/403.jpg;

}

root /opt/www/image;

}

以上所有来至domain.com和域名以及baidu和google的站点都可以访问到当前站点的图片,如果来源域名不在这个列表中，那么\$invalid_referer等于1，在if语句中返回一个403给用户，这样用户便会看到一个403的页面,如果使用下面的rewrite，那么盗链的图片都会显示403.jpg。none规则实现了允许空referer访问，即当直接在浏览器打开图片，referer为空时，图片仍能正常显示.

[root\@loya \~]\# curl -I http://qingkang.me/1.jpg -H
'Referer:http://www.baidu.com'

HTTP/1.1 200 OK

Server: nginx/1.8.1

Date: Fri, 16 Dec 2016 14:56:51 GMT

Content-Type: image/jpeg

Content-Length: 17746

Last-Modified: Tue, 16 Aug 2016 03:20:21 GMT

Connection: keep-alive

ETag: "57b28675-4552"

Accept-Ranges: bytes

[root\@loya \~]\# curl -I http://qingkang.me/1.jpg -H
'Referer:http://www.qq.com'

HTTP/1.1 403 Forbidden

Server: nginx/1.8.1

Date: Fri, 16 Dec 2016 14:56:58 GMT

Content-Type: text/html; charset=utf-8

Content-Length: 168

Connection: keep-alive

指令

语法: valid_referers none \| blocked \| server_names \| string …;

配置段: server, location

指定合法的来源'referer',
他决定了内置变量\$invalid_referer的值，如果referer头部包含在这个合法网址里面，这个变量被设置为0，否则设置为1.
需要注意的是：这里并不区分大小写的.

参数说明：

none “Referer” 为空

blocked
“Referer”不为空，但是里面的值被代理或者防火墙删除了，这些值都不以http://或者https://开头，而是“Referer:
XXXXXXX”这种形式

server_names “Referer”来源头部包含当前的server_names（当前域名）

arbitrary string
任意字符串,定义服务器名或者可选的URI前缀.主机名可以使用\*开头或者结尾，在检测来源头部这个过程中，来源域名中的主机端口将会被忽略掉

regular expression 正则表达式,\~表示排除https://或http://开头的字符串.

注意

通过Referer实现防盗链比较基础，仅可以简单实现方式资源被盗用。构造Referer的请求很容易实现。
