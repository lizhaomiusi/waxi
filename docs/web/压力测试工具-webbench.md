压力测试工具-webbench  
简述  
偶然情况下看到一款性能测试工具webbench，看着挺不错的记录一下安装过程，在以后项目上线过程中可以压一压一些页面的并发情况，对项目性能有个大致的了解。  
原理  
webbench首先fork出多个子进程，每个子进程都循环做web访问测试。子进程把访问的结果通过pipe告诉父进程，父进程做最终的统计结果百科介绍  
安装过程  
yum install -y gcc ctags  
wget http://www.ha97.com/code/webbench-1.5.tar.gz  
tar -xvf webbench-1.5.tar.gz  
cd webbench-1.5  
\# 这一步可能遇到如下错误，手动创建目录即可  
make && make install  
mkdir -p /usr/local/man/man1  
make && make install  
  
\# 使用说明 通过webbench --help 命令查看  
[root\@node1 data]\# webbench --help  
webbench [option]... URL  
-f\|--force Don't wait for reply from server.  
-r\|--reload Send reload request - Pragma: no-cache.  
-t\|--time \<sec\> Run benchmark for \<sec\> seconds. Default 30.  
-p\|--proxy \<server:port\> Use proxy server for request.  
-c\|--clients \<n\> Run \<n\> HTTP clients at once. Default one.  
-9\|--http09 Use HTTP/0.9 style requests.  
-1\|--http10 Use HTTP/1.0 protocol.  
-2\|--http11 Use HTTP/1.1 protocol.  
--get Use GET request method.  
--head Use HEAD request method.  
--options Use OPTIONS request method.  
--trace Use TRACE request method.  
-?\|-h\|--help This information.  
-V\|--version Display program version.  
使用  
不是专业测试，再次使用此工具模拟对一个项目进行压测，使用两个参数 c
并发客户端数，t 运行时长，我们来对http://www.baidu.com 做压测看测试报告内容  
  
执行命令：webbench -c 10 http://www.baidu.com  
命令就是用10个客户端并发百度网站30秒，但是在执行的命令报错了：Invalid URL syntax
- hostname don't ends with '/'。解决办法就是在url后加个“/”  
  
执行结果反馈内容：  
  
[root\@node1 data]\# webbench -c 10 -t 30 http://www.baidu.com/  
Webbench - Simple Web Benchmark 1.5  
Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.  
  
Benchmarking: GET http://www.baidu.com/  
10 clients, running 30 sec.  
  
Speed=2254 pages/min, 4188293 bytes/sec.  
Requests: 1110 susceed, 17 failed.  
[root\@centos7 webbench-1.5]\# webbench -c 1 -t 1
http://192.168.21.11/index.html  
Webbench - Simple Web Benchmark 1.5  
Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.  
  
Benchmarking: GET http://192.168.21.11/index.html  
1 client, running 1 sec.  
  
Speed=64619 pages/min, 262788 bytes/sec. \# 一个客户端一分钟响应页面数和字节数  
Requests: 1077 susceed, 0 failed. \# 1个客户端1秒产生了1077个请求 0个失败
