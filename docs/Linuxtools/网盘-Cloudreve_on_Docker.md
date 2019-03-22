下载Docker镜像到本地

https://ilemonrain.com/docker/cloudreve.html  
https://www.jianshu.com/p/a7d033e08247  
  
1、镜像说明  
此镜像基于 ilemonrain/lamp
作为母镜像，进行了修改以适配Cloudreve的环境要求（但我知道有些地方还是没优化到位……）。到目前为止。此镜像已经集成：  
  
一套LAMP环境，包括：  
  
L：Alpine Linux 3.7.0  
A：Apache 2.4.29  
M：MariaDB 10.1.28  
P：PHP 7.1.15  
Cloudreve (使用Composer+Git同步官网最新版本)  
Google 2FA 组件 (用于支持Google两步验证)  
启动过程中的日志追踪功能 (docker run -t 或者 docker logs)  
计划中 (也可能鸽掉不做) 的功能：  
Apache 2 SSL支持 (目前正在做)  
Let's Encrypt 支持 (用于部署时自动申请SSL证书)  
Sendfile 下载支持 (Apache2的扩展，用于减轻服务器下载压力)  
一些Apache2/PHP7/MariaDB的性能优化  
目前完全是一时冲动（什么鬼）写出来的镜像，所以以后可能会坑掉不写，如果有什么好的建议或者紧急BUG提交，请Email到：ilemonrain\@ilemonrain.com，谢谢你们的支持！  
  
2、部署教程  
由于Docker的特殊性(虚拟化要求)，此教程不适用于OpenVZ虚拟化架构！OpenVZ虚拟化的请等待我的后续部署教程！  
(1) 检测你的服务器虚拟化类型！  
如何检测自己的服务器虚拟化类型：  
  
CentOS/Fedora:  
yum install virt-what -y  
virt-what  
Ubuntu/Debian:  
apt-get install virt-what -y  
virt-what  
返回以下结果，请继续往下阅读教程：  
  
KVM  
Xen  
Xen-PV  
Xen-HVM  
VMware  
不显示任何结果 (多数情况下是独服)  
返回以下结果，说明此教程不适合你的服务器：  
  
OpenVZ  
Docker  
乱七八糟的东西 (virt-what运行报错)  
  
(2) 安装Docker环境  
首先，在你的服务器上，执行以下命令，安装Docker环境并设为开机自启动：  
  
CentOS/Fedora:  
yum install docker -y  
systemctl enable docker  
systemctl start docker  
Ubuntu/Debian:  
apt-get install docker.io  
systemctl enable docker  
systemctl start docker  
之后，运行命令：  
  
docker info  
来确定你的Docker是否成功启动。如果返回关于你的Docker的相关信息，就像这样：  
  
[root\@docker-host \~]\# docker info  
Containers: 0  
Running: 0  
Paused: 0  
Stopped: 0  
Images: 0  
Server Version: 1.13.1  
(.........)  
如果返回以下信息，则说明你的Docker没有正确启动：  
  
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the
docker daemon running?  
则请检查你的Docker是否正确安装，服务是否正确启动。  
  
一个我常遇到的问题：selinux权限限制。  
  
遇到这种情况，请执行命令：  
  
setenforce 0  
然后再尝试重新启动Docker进程，很多时候都会奏效。  
  
(3) 下载Docker镜像到本地  
执行以下命令，将Docker镜像从Docker Hub上拉回本地：  
  
docker pull ilemonrain/cloudreve  
拉取镜像的速度取决于你服务器的国际出口速度。  
  
一般情况下，美帝的服务器基本上就是秒速拉回来，国内的服务器往往非常慢。  
  
请参考这里 如何为国内服务器加速Docker Hub镜像拉取：  
  
https://www.docker-cn.com/registry-mirror  
等待拉取结束后，继续部署过程。  
  
(4) 启动Docker镜像  
启动命令格式如下：  
  
docker run [-d/-t] -p 80:80 -e CLOUDREVE_URL="[Cloudreve URL]" -v
/cloudreve:/cloudreve --name docker-cloudreve ilemonrain/cloudreve  
  
启动命令行说明：  
  
-d/-t：决定是以后台运行模式启动或是前台监控模式启动。  
  
使用 -d
参数启动，镜像将不会输出任何日志到你的Console，直接以Daemon模式启动。Deamon模式启动下，可以使用
docker logs docker-cloudreve 命令显示启动日志。  
使用 -t
参数启动，将会直接Attach你的镜像到你的Console，这个模式启动下，你可以直观的看到镜像的启动过程，适合于初次部署镜像，以及镜像Debug部署使用。你可以使用
Ctrl+C 将Docker镜像转入后台运行，使用docker logs docker-cloudreve
命令显示启动日志。  
-p
80:80：暴露你的Docker容器内部的80端口，到你容器外部的80端口。目前由于开发状态原因，不建议修改此端口。  
  
-e CLOUDREVE_URL="[Cloudreve
URL]"：Cloudreve绑定的地址，此参数务必严格填写，不能丢掉http/https前缀和结尾的斜杠！  
  
-v /cloudreve:/cloudreve：将Docker容器中的 /cloudreve 目录，映射到宿主机的
/cloudreve目录，冒号前面的是映射路径，冒号后的为容器中路径
(强烈建议进行映射，以确保容器中数据的安全，避免在容器意外崩溃时导致数据丢失)  
  
容器中可以映射的路径：  
  
/cloudreve ： Cloudreve 程序目录以及网盘文件目录  
/var/lib/mysql ： MariaDB (MySQL)数据库文件目录  
--name docker-cloudreve：Docker容器的名称，可以自行修改  
  
ilemonrain/cloudreve：启动的Docker镜像名称，请不要修改！  
  
最终结合实际  
docker run -t -p 80:80 -v /cloudreve:/cloudreve -e
CLOUDREVE_URL="\<http://127.0.0.1/\> --name docker-cloudreve
registry.docker-cn.com/ilemonrain/cloudreve  
  
(5) 启动过程  
根据我目前设置的entrypoint.sh，目前的启动过程如下：  
  
通过命令行，启动Docker容器  
【开发中】Apache2 初始化  
MariaDB (MySQL) 初始化  
安装Cloudreve (通过php composer)  
安装 Google 2FA 验证器插件 (通过php composer)  
安装 用于Google 2FA 验证器的二维码插件 (通过php composer)  
输出容器相关的信息  
以前台模式启动Apache2
