Windows下Apache设置文件夹目录认证密码的方法 (2016-12-16 10:45:29)  
  
很简单点事，弄的那么复杂，我来写个简单点的  
  
1：在跟目录下建立.htaccess文件 ，如果已经有了，就不用建立了  
2：在.htaccess下加入如下代码  
这个是windows下apahce  
  
AuthName "Login"  
AuthType basic  
AuthUserFile "c:\\user.d"  
require valid-user  
  
---  
  
如果是虚拟主机的话，先装个PHP探针，探测到程序的绝对路径，比如万网的绝对路径是  
  
/usr/home/qxu1587790257/htdocs  
  
那就把user.txt放到根目录（放到哪里，自定，名字自定，可以4521fdsfu.txt)  
  
写法如下  
  
AuthName "Login"  
AuthType basic  
AuthUserFile /usr/home/qxu1587790257/htdocs/user.txt  
require valid-user  
require valid-user

\---  
  
说明，其中“login"可以替换成中文, "D:\\USER.TXT”是密码存储文件存放点位置  
  
用户密码信息保存在"D:\\user.txt"，不要将它放在网站目录，以防被下载。  
  
---  
  
如果是NGINX的话，则更简单，打开nginx/conf下的 nginx的conf文件  
  
LINUX主机 加入背景颜色为绿色的字段即可
passwd.db为账户存储文件至于后缀为.db还是.txt.无所谓了  
  
server {  
listen 80; //监听端口为80  
server_name www1.rsyslog.org; //虚拟主机网址  
location / {  
root sites/www1; //虚拟主机网站根目录  
index index.html index.htm; //虚拟主机首页  
auth_basic "secret"; //虚拟主机认证命名  
auth_basic_user_file /usr/local/nginx/passwd.db; //虚拟主机用户名密码认证数据库  
}  
  
WINDOWS主机  
  
server {  
listen 80; //监听端口为80  
server_name www1.rsyslog.org; //虚拟主机网址  
location / {  
root sites/www1; //虚拟主机网站根目录  
index index.html index.htm; //虚拟主机首页  
auth_basic "secret"; //虚拟主机认证命名  
auth_basic_user_file D:/passwd.txt; //虚拟主机用户名密码认证数据库  
}  
  
---  
  
下面我们来用Apache2\\bin\\htpasswd.exe 来生成密码，例如：  
添加一个用户，我们可以使用-b和-c参数  
原有的密码文件中新增一个用户，我们可以使用-b参数  
不更新密码文件，而只显示加密后的用户名和密码，我们可以使用-n参数  
删除已经在密码文件存在的用户，我们可以通过-D参数来实现  
  
D:\\Apache2\\bin\>htpasswd -bc d:\\user.txt xiaom xiaom\#234  
New password: \*\*\*  
Re-type new password: \*\*\*  
Adding password for user piaoyi.org  
  
当然，最简单的办法，莫过于在线生成  
  
http://tool.oschina.net/htpasswd  
  
生成的密码是这个德行的  
  
建立名为 lyd和lyd2的用户 密码是123。可以建立多个帐户。  
至此，我们已经完成对"D:\\wwwroot\\test"目录的密码认证  
  
http://www.piaoyi.org/network/Windows-Apache-AuthType-basic.html
