AB网站测试工具  
-n \# 测试会话中所执行的请求总个数，默认执行一个请求  
-c \# 一次产生的请求个数，默认是一次一个  
1.独立安装  
ab运行需要依赖apr-util包，安装命令为：  
yum install apr-util -y  
因为在后面的命令中要用到yumdownload，如果没有找到 yumdownload
命令可以使用以下命令安装依赖 yum-utils中的yumdownload 工具  
yum install yum-utils -y  
2.安装完成后执行以下指令  
解开后就能得到独立的 ab可执行文件了。  
操作完成后 将会产生一个 usr 目录 ab文件就在这个usr/bin 目录中  
cd /opt  
mkdir abtmp  
cd ./abtmp  
yum install yum-utils.noarch  
yumdownloader httpd-tools\*  
rpm2cpio httpd-\*.rpm \| cpio -idmv  
ln -s /opt/abtmp/usr/bin/ab /usr/local/bin/ab  
ab -n 1000 -c 1000 http://192.168.21.11/index.html  
  
简单使用  
  
1. 最基本的关心两个选项 -c -n  
例： ./ab -c 1000 -n 10000 http://127.0.0.1/index.php  
  
-c 100 即：每次并发100个  
-n 10000 即： 共发送10000个请求  
  
Concurrency Level: 100 //并发请求数  
Time taken for tests: 50.872 seconds //整个测试持续的时间  
Complete requests: 1000 //完成的请求数  
Failed requests: 0 //失败的请求数  
Total transferred: 13701482 bytes //整个场景中的网络传输量  
HTML transferred: 13197000 bytes //整个场景中的HTML内容传输量  
Requests per second: 19.66 [\#/sec] (mean)
//吞吐率，大家最关心的指标之一，相当于 LR 中的每秒事务数，后面括号中的 mean
表示这是一个平均值  
Time per request: 5087.180 [ms] (mean)
//用户平均请求等待时间，大家最关心的指标之二，相当于 LR
中的平均事务响应时间，后面括号中的 mean 表示这是一个平均值  
Time per request: 50.872 [ms] (mean, across all concurrent requests)
//服务器平均请求处理时间，大家最关心的指标之三  
Transfer rate: 263.02 [Kbytes/sec] received
//平均每秒网络上的流量，可以帮助排除是否存在网络流量过大导致响应时间延长的问题  
  
需了解几个关于压力测试的概念  
  
吞吐率（Requests per second）  
概念：服务器并发处理能力的量化描述，单位是reqs/s，指的是某个并发用户数下单位时间内处理的请求数。某个并发用户数下单位时间内能处理的最大请求数，称之为最大吞吐率。  
计算公式：总请求数 / 处理完成这些请求数所花费的时间，即  
Request per second = Complete requests / Time taken for tests  
  
并发连接数（The number of concurrent connections）  
概念：某个时刻服务器所接受的请求数目，简单的讲，就是一个会话。  
  
并发用户数（The number of concurrent users，Concurrency Level）  
概念：要注意区分这个概念和并发连接数之间的区别，一个用户可能同时会产生多个会话，也即连接数。  
  
用户平均请求等待时间（Time per request）  
计算公式：处理完成所有请求数所花费的时间/ （总请求数 / 并发用户数），即  
Time per request = Time taken for tests /（ Complete requests / Concurrency
Level）  
  
服务器平均请求等待时间（Time per request: across all concurrent requests）  
计算公式：处理完成所有请求数所花费的时间 / 总请求数，即  
Time taken for / testsComplete requests  
可以看到，它是吞吐率的倒数。  
同时，它也=用户平均请求等待时间/并发用户数，即  
Time per request / Concurrency Level  
  
Usage: ab [options] [http[s]://]hostname[:port]/path  
Options are:  
-n requests Number of requests to perform //请求链接数  
-c concurrency Number of multiple requests to make at a time //表示并发数  
-t timelimit Seconds to max. to spend on benchmarking  
This implies -n 50000  
-s timeout Seconds to max. wait for each response  
Default is 30 seconds  
-b windowsize Size of TCP send/receive buffer, in bytes  
-B address Address to bind to when making outgoing connections  
-p postfile File containing data to POST. Remember also to set -T  
-u putfile File containing data to PUT. Remember also to set -T  
-T content-type Content-type header to use for POST/PUT data, eg.  
'application/x-www-form-urlencoded'  
Default is 'text/plain'  
-v verbosity How much troubleshooting info to print  
-w Print out results in HTML tables  
-i Use HEAD instead of GET  
-x attributes String to insert as table attributes  
-y attributes String to insert as tr attributes  
-z attributes String to insert as td or th attributes  
-C attribute Add cookie, eg. 'Apache=1234'. (repeatable)  
-H attribute Add Arbitrary header line, eg. 'Accept-Encoding: gzip'  
Inserted after all normal header lines. (repeatable)  
-A attribute Add Basic WWW Authentication, the attributes  
are a colon separated username and password.  
-P attribute Add Basic Proxy Authentication, the attributes  
are a colon separated username and password.  
-X proxy:port Proxyserver and port number to use  
-V Print version number and exit  
-k Use HTTP KeepAlive feature  
-d Do not show percentiles served table.  
-S Do not show confidence estimators and warnings.  
-q Do not show progress when doing more than 150 requests  
-l Accept variable document length (use this for dynamic pages)  
-g filename Output collected data to gnuplot format file.  
-e filename Output CSV file with percentages served  
-r Don't exit on socket receive errors.  
-h Display usage information (this message)  
-Z ciphersuite Specify SSL/TLS cipher suite (See openssl ciphers)  
-f protocol Specify SSL/TLS protocol  
(SSL3, TLS1, TLS1.1, TLS1.2 or ALL)
