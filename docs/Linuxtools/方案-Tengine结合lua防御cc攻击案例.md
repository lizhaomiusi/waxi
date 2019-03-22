方案-Tengine 结合 lua 防御 cc 攻击案例

下载和安装 tengine 与 luajit

tengine下载地址 http://tengine.taobao.org/
选择稳定的安装包下载编译安装即可。这里用的包是 tengine-2.1.1.tar.gz。

luajit 下载地址 http://luajit.org/download.html
选择稳定的安装包下载编译安装即可。这里用的包是LuaJIT-2.0.4.tar.gz。

安装的步骤如下：

1、安装环境需要的基础文件

yum install zlib zlib-devel openssl openssl-devel pcre pcre-devel -y

2、下载和安装 LuaJIT-2.0.4.tar.gz

wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz

tar zxvf LuaJIT-2.0.4.tar.gz

cd LuaJIT-2.0.4

make

make install PREFIX=/usr/local/luajit

出现红框信息显示安装成功了，可以进行下一步了

3、下载和安装 tengine-2.1.1.tar.gz

wget http://tengine.taobao.org/download/tengine-2.1.1.tar.gz

tar zxvf tengine-2.1.1.tar.gz

cd tengine-2.1.1

./configure --prefix=/opt/nginx --with-http_lua_module
--with-luajit-lib=/usr/local/luajit/lib/
--with-luajit-inc=/usr/local/luajit/include/luajit-2.0/
--with-ld-opt=-Wl,-rpath,/usr/local/luajit/lib

make && make install

下载和配置 ngx_lua_waf

nginx下常见的开源 waf 有 mod_security、naxsi、ngx_lua_waf 这三个，ngx_lua_waf
性能高和易用性强，基本上零配置，而且常见的攻击类型都能防御，是比较省心的选择。

其git 地址为 https://github.com/loveshell/ngx_lua_waf

1.下载配置文件

wget https://github.com/loveshell/ngx_lua_waf/archive/master.zip

2. 解压缩

unzip master.zip

3. 移动到nginx的目录下

mv ngx_lua_waf-master /opt/nginx/conf/

4. 重命名

cd /opt/nginx/conf/

mv ngx_lua_waf-master waf

5. 修改 ngx_lua_waf 配置文件适应当前的 nginx
环境。修改以下文件的三行即可（修改/opt/nginx/conf/waf下的config.lua文件，将RulePath和logdir改为实际的目录：）

cat /opt/nginx/conf/waf/config.lua\|head -n3

RulePath = "/opt/nginx/conf/waf/wafconf/"

attacklog = "on"

logdir = "/opt/nginx/logs/waf"

修改 tengine 的配置文件应用 ngx_lua_waf

在 nginx.conf 的 http 段添加

lua_package_path "/opt/nginx/conf/waf/?.lua";

lua_shared_dict limit 10m;

init_by_lua_file /opt/nginx/conf/waf/init.lua;

access_by_lua_file /opt/nginx/conf/waf/waf.lua;

启动 tengine--nginx 服务

/opt/nginx/sbin/nginx -t

the configuration file /opt/nginx/conf/nginx.conf syntax is ok

/opt/nginx/sbin/nginx -s reload

测试攻防的效果

1. 任意文件读取测试示例输出：

x.x.x.x/ethnicity.php?id=../etc/passwd

提示

您的请求带有不合法参数，已被网站管理员拦截

2. sql 注入测试示例输出：

x.x.x.x/ethnicit.php?id=1%20select%20\*%20from%20ethicity.user;

您的请求带有不合法参数，已被网站管理员拦截
