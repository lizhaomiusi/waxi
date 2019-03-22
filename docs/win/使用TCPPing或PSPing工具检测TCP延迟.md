使用TCPPing或PSPing工具检测TCP延迟

测试网络的延迟可以使用ping，mtr，tracert等命令，但是测试TCP端口的访问延迟无法使用以上软件完成，此时可以使用TCPPing或者PSPing来测试TCP端口的延迟情况。

TCPPing

到网上搜索tcping，下载该工具后。放到C:\\Windows\\System32目录下，

【开始】-\>【运行】-\>【cmd】 输入：tcping www.aliyun.com 80即可。类似如下图：

PSPing

请从微软官网上下载psping，该工具支持多种参数实现ICMP，UDP，TCP 协议的延迟探测。

https://technet.microsoft.com/en-us/sysinternals/psping.aspx

对于TCP而言，如下例：

psping -t www.aliyun.com
