NGINX+LUA实现WAF功能

1.1 什么是WAF

Web应用防护系统（也称：网站应用级入侵防御系统 。英文：Web Application
Firewall，简称： WAF）。利用国际上公认的一种说法：Web应用 防火墙
是通过执行一系列针对HTTP/HTTPS的 安全策略 来专门为Web应用提供保护的一款产品。  
  
1.2 WAF的功能  
• 支持IP白名单和黑名单功能，直接将黑名单的IP访问拒绝。  
• 支持URL白名单，将不需要过滤的URL进行定义。  
• 支持User-Agent的过滤，匹配自定义规则中的条目，然后进行处理（返回403）。  
• 支持CC攻击防护，单个URL指定时间的访问次数，超过设定值，直接返回403。  
• 支持Cookie过滤，匹配自定义规则中的条目，然后进行处理（返回403）。  
• 支持URL过滤，匹配自定义规则中的条目，如果用户请求的URL包含这些，返回403。  
• 支持URL参数过滤，原理同上。  
• 支持日志记录，将所有拒绝的操作，记录到日志中去  
  
1.3 WAF的特点  
• 异常检测协议  
Web应用防火墙会对HTTP的请求进行异常检测，拒绝不符合HTTP标准的请求。并且，它也可以只允许HTTP协议的部分选项通过，从而减少攻击的影响范围。甚至，一些Web应用防火墙还可以严格限定HTTP协议中那些过于松散或未被完全制定的选项。  
  
• 增强的输入验证  
增强输入验证，可以有效防止网页篡改、信息泄露、木马植入等恶意网络入侵行为。从而减小Web服务器被攻击的可能性。  
• 及时补丁  
修补Web安全漏洞，是Web应用开发者最头痛的问题，没人会知道下一秒有什么样的漏洞出现，会为Web应用带来什么样的危害。WAF可以为我们做这项工作了--只要有全面的漏洞信息WAF能在不到一个小时的时间内屏蔽掉这个漏洞。当然，这种屏蔽掉漏洞的方式不是非常完美的，并且没有安装对应的补丁本身就是一种安全威胁，但我们在没有选择的情况下，任何保护措施都比没有保护措施更好。  
• 基于规则的保护和基于异常的保护  
基于规则的保护可以提供各种Web应用的安全规则，WAF生产商会维护这个规则库，并时时为其更新。用户可以按照这些规则对应用进行全方面检测。还有的产品可以基于合法应用数据建立模型，并以此为依据判断应用数据的异常。但这需要对用户企业的应用具有十分透彻的了解才可能做到，可现实中这是十分困难的一件事情。  
• 状态管理  
WAF能够判断用户是否是第一次访问并且将请求重定向到默认登录页面并且记录事件。通过检测用户的整个操作行为我们可以更容易识别攻击。状态管理模式还能检测出异常事件（比如登陆失败），并且在达到极限值时进行处理。这对暴力攻击的识别和响应是十分有利的。  
• 其他防护技术  
WAF还有一些安全增强的功能，可以用来解决WEB程序员过分信任输入数据带来的问题。比如：隐藏表单域保护、抗入侵规避技术、响应监视和信息泄露保护。  
  
1.3WAF与网络防火墙的区别  
　　网络防火墙作为访问控制设备，主要工作在OSI模型三、四层，基于IP报文进行检测。只是对端口做限制，对TCP协议做封堵。其产品设计无需理解HTTP会话，也就决定了无法理解Web应用程序语言如HTML、SQL语言。因此，它不可能对HTTP通讯进行输入验证或攻击规则分析。针对Web网站的恶意攻击绝大部分都将封装为HTTP请求，从80或443端口顺利通过防火墙检测。  
　　一些定位比较综合、提供丰富功能的防火墙，也具备一定程度的应用层防御能力，如能根据TCP会话异常性及攻击特征阻止网络层的攻击，通过IP分拆和组合也能判断是否有攻击隐藏在多个数据包中，但从根本上说他仍然无法理解HTTP会话，难以应对如SQL注入、跨站脚本、cookie窃取、网页篡改等应用层攻击。  
　　web应用防火墙能在应用层理解分析HTTP会话，因此能有效的防止各类应用层攻击，同时他向下兼容，具备网络防火墙的功能。  
  
二、使用nginx配置简单实现403和404  
  
2.1 小试身手之rerurn 403  
修改nginx配置文件在server中加入以下内容  
1. set \$block_user_agent 0;  
2. if ( \$http_user_agent \~ "Wget\|AgentBench"){  
3. set \$block_user_agent 1;  
4. }  
5. if (\$block_user_agent = 1) {  
6. return 403 ;  
7. }  
通过其他机器去wget，结果如下  


![](media/b7eb3f6d5b3482b501559efe5add3faa.wmf)

  
  
2.2小试身手之rerurn 404  
在nginx配置文件中加入如下内容，让访问sql\|bak\|zip\|tgz\|tar.gz的请求返回404  
1. location \~\* "\\.(sql\|bak\|zip\|tgz\|tar.gz)\$"{  
2. return 404  
3. }  
在网站根目录下放一个tar.gz  
[root\@iZ28t900vpcZ www]\# tar zcvf abc.tar.gz wp-content/  
通过浏览器访问结果如下，404已生效  
  
三、深入实现WAF  
  
3.1 WAF实现规划  
分析步骤如下：解析HTTP请求==》匹配规则==》防御动作==》记录日志  
具体实现如下：  
• 解析http请求：协议解析模块  
• 匹配规则：规则检测模块，匹配规则库  
• 防御动作：return 403 或者跳转到自定义界面  
• 日志记录：记录到elk中，画出饼图，建议使用json格式  
  
3.2安装nginx+lua  
由于nginx配置文件书写不方便，并且实现白名单功能很复杂，nginx的白名单也不适用于CC攻击，所以在这里使用nginx+lua来实现WAF，如果想使用lua，须在编译nginx的时候配置上lua，或者结合OpenResty使用,此方法不需要编译nginx时候指定lua  
  
3.2.1 编译nginx的时候加载lua  
环境准备：Nginx安装必备的Nginx和PCRE软件包。  
1. [root\@nginx-lua \~]\# cd /usr/local/src  
2. [root\@nginx-lua src]\# wget http://nginx.org/download/nginx-1.9.4.tar.gz  
3. [root\@nginx-lua src]\# wget
ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.gz  
其次，下载当前最新的luajit和ngx_devel_kit (NDK)，以及春哥编写的lua-nginx-module  
1. [root\@nginx-lua src]\# wget http://luajit.org/download/LuaJIT-2.0..tar.gz  
2. [root\@nginx-lua src]\# wget
https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz  
3. [root\@nginx-lua src]\# wget
https://github.com/openresty/lua-nginx-module/archive/v0.9.16.tar.gz  
最后，创建Nginx运行的普通用户  
1. [root\@nginx-lua src]\# useradd -s /sbin/nologin -M www  
解压NDK和lua-nginx-module  
1. [root\@openstack-compute-node5 src]\# tar zxvf v0.2.19.tar.gz  
2. [root\@openstack-compute-node5 src]\# tar zxvf v0.9.16.tar.gz  
安装LuaJIT Luajit是Lua即时编译器  
1. [root\@openstack-compute-node5 src]\# tar zxvf LuaJIT-2.0.3.tar.gz  
2. [root\@openstack-compute-node5 src]\# cd LuaJIT-2.0.3  
3. [root\@openstack-compute-node5 LuaJIT-2.0.3]\# make && make install  
安装Nginx并加载模块  
1. [root\@openstack-compute-node5 src]\# tar zxvf nginx-1.9.4.tar.gz  
2. [root\@openstack-compute-node5 src]\# cd nginx-1.9.4  
3. [root\@openstack-compute-node5 nginx-1.9.4]\# export
LUAJIT_LIB=/usr/local/lib  
4. [root\@openstack-compute-node5 nginx-1.9.4]\# export
LUAJIT_INC=/usr/local/include/luajit-2.0  
5. [root\@openstack-compute-node5 nginx-1.9.4]\# ./configure
--prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module
--with-http_stub_status_module --with-file-aio --with-http_dav_module
--add-module=../ngx_devel_kit-0.2.19/ --add-module=../lua-nginx-module-0.9.16/
--with-pcre=/usr/local/src/pcre-8.37  
6. [root\@openstack-compute-node5 nginx-1.5.12]\# make -j2 && make install  
7. [root\@openstack-compute-node5 \~]\# ln -s /usr/local/lib/libluajit-5.1.so.2
/lib64/libluajit-5.1.so.2 \#一定创建此软连接，否则报错  
安装完毕后，下面可以测试安装了，修改nginx.conf 增加第一个配置  
1. location /hello {  
2. default_type 'text/plain';  
3. content_by_lua 'ngx.say("hello,lua")';  
4. }  
5. [root\@openstack-compute-node5 \~]\# /usr/local/nginx-1.9.4/sbin/nginx -t  
6. [root\@openstack-compute-node5 \~]\# /usr/local/nginx-1.9.4/sbin/nginx  
效果如下

www.chuck-blog.com/hello  
  
3.2.3 Openresty部署  
安装依赖包  
1. [root\@iZ28t900vpcZ \~]\#yum install -y readline-devel pcre-devel
openssl-devel  
下载并编译安装openresty  
1. [root\@iZ28t900vpcZ \~]\#cd /usr/local/src  
2. [root\@iZ28t900vpcZ src]\#wget
https://openresty.org/download/ngx_openresty-1.9.3.2.tar.gz  
3. [root\@iZ28t900vpcZ src]\#tar zxf ngx_openresty-1.9.3.2.tar.gz  
4. [root\@iZ28t900vpcZ src]\#cd ngx_openresty-1.9.3.2  
5. [root\@iZ28t900vpcZ ngx_openresty-1.9.3.2]\# ./configure
--prefix=/usr/local/openresty-1.9.3.2 --with-luajit
--with-http_stub_status_module --with-pcre --with-pcre-jit  
6. [root\@iZ28t900vpcZ ngx_openresty-1.9.3.2]\#gmake && gmake install  
7. ln -s /usr/local/openresty-1.9.3.2/ /usr/local/openresty  
测试openresty安装  
1. [root\@iZ28t900vpcZ \~]\#vim /usr/local/openresty/nginx/conf/nginx.conf  
2. server {  
3. location /hello {  
4. default_type text/html;  
5. content_by_lua_block {  
6. ngx.say("HelloWorld")  
7. }  
8. }  
9. }  
测试并启动nginx  
1. [root\@iZ28t900vpcZ \~]\#/usr/local/openresty/nginx/sbin/nginx -t  
2. nginx: the configuration file
/usr/local/openresty-1.9.3.2/nginx/conf/nginx.conf syntax is ok  
3. nginx: configuration file /usr/local/openresty-1.9.3.2/nginx/conf/nginx.conf
test is successful  
4. [root\@iZ28t900vpcZ \~]\#/usr/local/openresty/nginx/sbin/nginx  
  
3.2.4WAF部署  
在github上克隆下代码  
1. [root\@iZ28t900vpcZ \~]\#git clone https://github.com/unixhot/waf.git  
2. [root\@iZ28t900vpcZ \~]\#cp -a ./waf/waf /usr/local/openresty/nginx/conf/  
修改Nginx的配置文件，加入（http字段）以下配置。注意路径，同时WAF日志默认存放在/tmp/日期_waf.log  
1. \#WAF  
2. lua_shared_dict limit 50m; \#防cc使用字典，大小50M  
3. lua_package_path "/usr/local/openresty/nginx/conf/waf/?.lua";  
4. init_by_lua_file "/usr/local/openresty/nginx/conf/waf/init.lua";  
5. access_by_lua_file "/usr/local/openresty/nginx/conf/waf/access.lua";  
6. [root\@openstack-compute-node5 \~]\# /usr/local/openresty/nginx/sbin/nginx -t  
7. [root\@openstack-compute-node5 \~]\# /usr/local/openresty/nginx/sbin/nginx  
根据日志记录位置，创建日志目录  
1. [root\@iZ28t900vpcZ \~]\#mkdir /tmp/waf_logs  
2. [root\@iZ28t900vpcZ \~]\#chown nginx.nginx /tmp/waf_logs  
  
3.3学习模块  
  
3.3.1学习配置模块  
WAF上生产之前，建议不要直接上生产，而是先记录日志，不做任何动作。确定WAF不产生误杀  
config.lua即WAF功能详解  
1. [root\@iZ28t900vpcZ waf]\# pwd  
2. /usr/local/nginx/conf/waf  
3. [root\@iZ28t900vpcZ waf]\# cat config.lua  
4. --WAF config file,enable = "on",disable = "off"  
5. --waf status  
6. config_waf_enable = "on" \#是否开启配置  
7. --log dir  
8. config_log_dir = "/tmp/waf_logs" \#日志记录地址  
9. --rule setting  
10. config_rule_dir = "/usr/local/nginx/conf/waf/rule-config"  
11. \#匹配规则缩放地址  
12. --enable/disable white url  
13. config_white_url_check = "on" \#是否开启url检测  
14. --enable/disable white ip  
15. config_white_ip_check = "on" \#是否开启IP白名单检测  
16. --enable/disable block ip  
17. config_black_ip_check = "on" \#是否开启ip黑名单检测  
18. --enable/disable url filtering  
19. config_url_check = "on" \#是否开启url过滤  
20. --enalbe/disable url args filtering  
21. config_url_args_check = "on" \#是否开启参数检测  
22. --enable/disable user agent filtering  
23. config_user_agent_check = "on" \#是否开启ua检测  
24. --enable/disable cookie deny filtering  
25. config_cookie_check = "on" \#是否开启cookie检测  
26. --enable/disable cc filtering  
27. config_cc_check = "on" \#是否开启防cc攻击  
28. --cc rate the xxx of xxx seconds  
29. config_cc_rate = "10/60" \#允许一个ip60秒内只能访问10此  
30. --enable/disable post filtering  
31. config_post_check = "on" \#是否开启post检测  
32. --config waf output redirect/html  
33. config_waf_output = "html" \#action一个html页面，也可以选择跳转  
34. --if config_waf_output ,setting url  
35. config_waf_redirect_url = "http://www.baidu.com"  
36. config_output_html=[[ \#下面是html的内容  
37. \<html\>  
38. \<head\>  
39. \<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /\>  
40. \<meta http-equiv="Content-Language" content="zh-cn" /\>  
41. \<title\>网站防火墙\</title\>  
42. \</head\>  
43. \<body\>  
44. \<h1 align="center"\> \#
您的行为已违反本网站相关规定，注意操作规范。详情请联微信公众号：chuck-blog。  
45. \</body\>  
46. \</html\>  
47. ]]  
  
3.4 学习access.lua的配置  
1. [root\@iZ28t900vpcZ waf]\# pwd  
2. /usr/local/openresty/nginx/conf/waf  
3. [root\@iZ28t900vpcZ waf]\# cat access.lua  
4. require 'init'  
5. function waf_main()  
6. if white_ip_check() then  
7. elseif black_ip_check() then  
8. elseif user_agent_attack_check() then  
9. elseif cc_attack_check() then  
10. elseif cookie_attack_check() then  
11. elseif white_url_check() then  
12. elseif url_attack_check() then  
13. elseif url_args_attack_check() then  
14. --elseif post_attack_check() then  
15. else  
16. return  
17. end  
18. end  
19. waf_main()  
书写书序：先检查白名单，通过即不检测；再检查黑名单，不通过即拒绝，检查UA，UA不通过即拒绝；检查cookie；URL检查;URL参数检查，post检查；  
  
3.5 启用WAF并测试  
  
3.5.1模拟sql注入即url攻击  
显示效果如下

www.chuck-blog.com/a.sql  
  
日志显示如下,记录了UA，匹配规则，URL，客户端类型，攻击的类型，请求的数据

tailf /tmp/waf_logs/2016-01-27_waf.log  
\#  
3.5.2 使用ab压测工具模拟防cc攻击  
1. [root\@linux-node3 \~]\# ab -c 100 -n 100 http://www.chuck-blog.com/index.php  
2. This is ApacheBench, Version 2.3 \<\$Revision: 1430300 \$\>  
3. Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/  
4. Licensed to The Apache Software Foundation, http://www.apache.org/  
5. Benchmarking www.chuck-blog.com (be patient).....done  
6. Server Software: openresty  
7. Server Hostname: www.chuck-blog.com  
8. Server Port: 80  
9. Document Path: /index.php  
10. Document Length: 0 bytes  
11. Concurrency Level: 100  
12. Time taken for tests: 0.754 seconds  
13. Complete requests: 10  
14. Failed requests: 90 \#config.lua中设置的，60秒内只允许10个请求  
15. Write errors: 0  
16. Non-2xx responses: 90  
17. Total transferred: 22700 bytes  
18. HTML transferred: 0 bytes  
19. Requests per second: 132.65 [\#/sec] (mean)  
20. Time per request: 753.874 [ms] (mean)  
21. Time per request: 7.539 [ms] (mean, across all concurrent requests)  
22. Transfer rate: 29.41 [Kbytes/sec] received  
23. Connection Times (ms)  
24. min mean[+/-sd] median max  
25. Connect: 23 69 20.2 64 105  
26. Processing: 32 180 144.5 157 629  
27. Waiting: 22 179 144.5 156 629  
28. Total: 56 249 152.4 220 702  
29. Percentage of the requests served within a certain time (ms)  
30. 50% 220  
31. 66% 270  
32. 75% 275  
33. 80% 329  
34. 90% 334  
35. 95% 694  
36. 98% 701  
37. 99% 702  
38. 100% 702 (longest request)  
39. \`\`\`  
40. \#\#\#3.5.3 模拟ip黑名单  
41. 将请求ip放入ip黑名单中  
[root\@iZ28t900vpcZ rule-config]\# echo “1.202.193.133”
\>\>/usr/local/openresty/nginx/conf/waf/rule-config/blackip.rule  
1. 显示结果如下  
2.
![](ca1fa711-48e6-4041-a367-b15db7bf2d2f_128_files/c71edccb-507c-4340-a1fc-ad03e300a2fa.png)  
3. \#\#\#3.5.4 模拟ip白名单  
4.
将请求ip放入ip白名单中，此时将不对此ip进行任何防护措施，所以sql注入时应该返回404  
[root\@iZ28t900vpcZ rule-config]\# echo “1.202.193.133”
\>\>/usr/local/openresty/nginx/conf/waf/rule-config/whiteip.rule  
1. 显示结果如下  
2.
![](ca1fa711-48e6-4041-a367-b15db7bf2d2f_128_files/3ded0e02-480f-48f4-8aab-41aff0fc5538.png)  
3. \#\#\#3.5.5 模拟URL参数检测  
4. 浏览器输入www.chuck-blog.com/?a=select \* from table  
5. 显示结果如下  
6.
![](ca1fa711-48e6-4041-a367-b15db7bf2d2f_128_files/744e4a20-5558-43fc-9f50-1546cbc765a3.png)  
7. 详细规定在arg.rule中有规定,对请求进行了规范  
8. \`\`\`bash  
9. [root\@iZ28t900vpcZ rule-config]\#
/usr/local/openresty/nginx/conf/waf/rule-config/cat args.rule  
10. \\.\\./  
11. \\:\\\$  
12. \\\$\\{  
13. select.+(from\|limit)  
14. (?:(union(.\*?)select))  
15. having\|rongjitest  
16. sleep\\((\\s\*)(\\d\*)(\\s\*)\\)  
17. benchmark\\((.\*)\\,(.\*)\\)  
18. base64_decode\\(  
19. (?:from\\W+information_schema\\W)  
20. (?:(?:current_)user\|database\|schema\|connection_id)\\s\*\\(  
21. (?:etc\\/\\W\*passwd)  
22. into(\\s+)+(?:dump\|out)file\\s\*  
23. group\\s+by.+\\(  
24. xwork.MethodAccessor  
25.
(?:define\|eval\|file_get_contents\|include\|require\|require_once\|shell_exec\|phpinfo\|system\|passthru\|preg_\\w+\|execute\|echo\|print\|print_r\|var_dump\|(fp)open\|alert\|showmodaldialog)\\(  
26. xwork\\.MethodAccessor  
27. (gopher\|doc\|php\|glob\|file\|phar\|zlib\|ftp\|ldap\|dict\|ogg\|data)\\:\\/  
28. java\\.lang  
29. \\\$_(GET\|post\|cookie\|files\|session\|env\|phplib\|GLOBALS\|SERVER)\\[  
30.
\\\<(iframe\|script\|body\|img\|layer\|div\|meta\|style\|base\|object\|input)  
31. (onmouseover\|onerror\|onload)\\=  
32. [root\@iZ28t900vpcZ rule-config]\# pwd  
33. /usr/local/openresty/nginx/conf/waf/rule-config  
  
四、防cc攻击利器之httpgrard  
  
4.1 httpgrard介绍  
HttpGuard是基于openresty,以lua脚本语言开发的防cc攻击软件。而openresty是集成了高性能web服务器Nginx，以及一系列的Nginx模块，这其中最重要的，也是我们主要用到的nginx
lua模块。HttpGuard基于nginx
lua开发，继承了nginx高并发，高性能的特点，可以以非常小的性能损耗来防范大规模的cc攻击。  
  
4.2 httpgrard防cc特效  
• 限制访客在一定时间内的请求次数  
• 向访客发送302转向响应头来识别恶意用户,并阻止其再次访问  
• 向访客发送带有跳转功能的js代码来识别恶意用户，并阻止其再次访问  
• 向访客发送cookie来识别恶意用户,并阻止其再次访问  
• 支持向访客发送带有验证码的页面，来进一步识别，以免误伤  
• 支持直接断开恶意访客的连接  
• 支持结合iptables来阻止恶意访客再次连接  
• 支持白名单功能  
• 支持根据统计特定端口的连接数来自动开启或关闭防cc模式  
详见github地址https://github.com/centos-bz/HttpGuard，在后续的博文中会加入此功能  
  
五、WAF上线  
• 初期上线只记录日志，不开启WAF，防止误杀  
• WAF规则管理使用saltstack工具  
• 要知道并不是有了WAF就安全，存在人为因素
