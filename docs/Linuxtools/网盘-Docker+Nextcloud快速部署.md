Docker+Nextcloud快速部署

https://www.cnblogs.com/Timesi/archive/2018/09/21/9688463.html  
  
各位大佬好，，今天要快速部署一个人网盘。  
有多快呢，，，5分钟吧，因为我们使用Docker部署。  
Docker基础可以看看我之前的博文。（点这里点这里
\<https://www.cnblogs.com/Timesi/p/9273015.html\>）  
那么，，，开始吧。  
安装的是Centos7的系统，要安装的网盘叫Nextcloud  
下面开始安装  
  
第一步  
老规矩，先安装Docker环境.  
命令如下：  
[root\@izt8mvnno1ny1dz \~]\# yum install -y docker  
[root\@izt8mvnno1ny1dz \~]\# systemctl start docker  
[root\@izt8mvnno1ny1dz \~]\# systemctl enable docker  
  
第二部  
查找Nextcloud网盘的镜像  
[root\@izt8mvnno1ny1dz \~]\# docker search nextcloud  
[root\@izt8mvnno1ny1dz \~]\# docker pull docker.io/nextcloud  
  
第三步  
容器拉取到本地之后，就该启用容器了。  
[root\@izt8mvnno1ny1dz \~]\# docker run -d --restart=always --name nextcloud -p
80:80 -v /root/nextcloud:/data docker.io/nextcloud  
ae96013c7f0ab05194a4488d1fa61b1c6274c272a53b3d418418b56a88e2e230  
[root\@izt8mvnno1ny1dz \~]\# docker ps -a  
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES  
ae96013c7f0a docker.io/nextcloud "/entrypoint.sh ap..." 6 seconds ago Up 6
seconds 0.0.0.0:80-\>80/tcp
nextcloud这里可以看到已经在后台运行了，这就部署好了。  
  
第四步  
在浏览器地址栏输入你的IP地址，可以访问到Nextcloud的Web页面。  
  
如果访问不到，先重启一下docker服务，命令如下：  
[root\@izt8mvnno1ny1dz \~]\# systemctl restart docker \#
如果还是不行，那么就关闭防火墙服务吧。  
[root\@izt8mvnno1ny1dz \~]\# systemctl stop firewalld  
[root\@izt8mvnno1ny1dz \~]\# systemctl status firewalld \# 查看一下防火墙状态  
  
接着完成完成网盘管理员账号的注册，使用默认数据库（当然，也可以起一个Mysql的容器，用来连接），然后完成注册，就可以登录了。  
  
这样就愉快的搭建完成了，是不是五分钟快速搭建！  
最后扔下自己的个人博客链接 https://www.gubeiqing.cn/
