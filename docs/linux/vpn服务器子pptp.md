### 搭建VPN服务器之PPTP

.

**1、查看系统是否支持PPP**

一般自己的系统支持，VPS需要验证。

\[root@oldboyedu ~\]\# cat \/dev\/ppp

cat: \/dev\/ppp: No such device or address

如果出现以上提示则说明ppp是开启的，可以正常架设pptp服务，若出现Permission denied等其他提示，你需要先去VPS面板里看看有没有enable ppp的功能开关，如果没有则需要发个消息给你的提供商，让他们帮你开通，否则就不必要看下去了，100%无法成功配置PPTP。

**2、设置内核转发**

\[root@oldboyedu ~\]\# grep forw \/etc\/sysctl.conf

\# Controls IP packet forwarding

net.ipv4.ip\_forward = 0

\[root@oldboyedu ~\]\# sed -i 's\#net.ipv4.ip\_forward = 0\#net.ipv4.ip\_forward = 1\#g' \/etc\/sysctl.conf

\[root@oldboyedu ~\]\# grep forw \/etc\/sysctl.conf

\# Controls IP packet forwarding

net.ipv4.ip\_forward = 1

\[root@oldboyedu ~\]\# sysctl -p

**3、安装PPTP**

\# 需要安装epel源

wget -O \/etc\/yum.repos.d\/epel.repo http:\/\/mirrors.aliyun.com\/repo\/epel-6.repo

yum -y install pptpd

**4、配置PPTP**

\[root@oldboyedu ~\]\# vim \/etc\/pptpd.conf

localip 10.0.0.9

remoteip 192.168.0.234-238

\# 添加本机公网IP（localip），分配VPN用户的内网网段（remoteip）。

**5、设置用户与密码**

\[root@oldboyedu ~\]\# vim \/etc\/ppp\/chap-secrets

oldboy \* 123456 \*

**6、启动pptp**

\[root@oldboyedu ~\]\# \/etc\/init.d\/pptpd start

Starting pptpd: \[ OK \]

\[root@oldboyedu ~\]\# netstat -tunlp\|grep 1723

tcp 0 0 0.0.0.0:1723 0.0.0.0:\* LISTEN 26574\/pptpd

**7、通过windows客户端连接VPN**

控制面板\网络和Internet\网络和共享中心

