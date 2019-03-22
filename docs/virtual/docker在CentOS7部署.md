Docker 在 CentOS 系统上的部署过程

主要内容

部署docker

docker基本用法

镜像制作

**部署Docker**

Docker要求64位的系统且内核版本至少为3.10。

[root\@docker1 \~]\# cat /etc/redhat-release

CentOS Linux release 7.5.1804 (Core)

[root\@docker1 \~]\# uname -r

3.10.0-862.el7.x86_64

关闭防火墙、selinux

\# 添加yum源。

yum install epel-release -y

yum clean all

yum list

\# 安装并运行Docker。

yum install docker-io -y

systemctl start docker

\# 检查安装结果。

docker info

**Docker基本用法**

Docker守护进程管理。

systemctl start docker \#运行Docker守护进程

systemctl stop docker \#停止Docker守护进程

systemctl restart docker \#重启Docker守护进程

镜像管理。

docker pull registry.cn-hangzhou.aliyuncs.com/lxepoo/apache-php5

修改标签，可以修改镜像标签以便记忆区分。

docker tag registry.cn-hangzhou.aliyuncs.com/lxepoo/apache-php5:latest aliweb:v1

查看已有镜像。

docker images

强制删除镜像。

docker rmi -f registry.cn-hangzhou.aliyuncs.com/lxepoo/apache-php5

容器管理。

e121d5f99e1e是执行docker images命令查询到的IMAGE ID，使用docker
run命令进入容器。

docker run -ti e121d5f99e1e /bin/bash

使用exit可以退出当前容器。

run命令加上-d参数可以在后台运行容器，-name指定容器命名为apache。

docker run -d --name apache e121d5f99e1e

进入后台运行的容器。

docker exec -ti apache /bin/bash

将容器做成镜像。

docker commit containerID/containerName newImageName:tag

为了方便测试和恢复，先将源镜像运行起来后再做一个命名简单的镜像做测试。

docker commit 4c8066cd8c01 apachephp:v1

运行容器并将宿主机的8080端口映射到容器里去。

docker run -d -p 8080:80 apachephp:v1

在浏览器输入宿主机ip加8080端口访问测试，出现以下内容则说明运行成功。

**制作镜像**

准备dockerfile内容

\# vim Dockerfile

FROM apachephp:v1 \#声明基础镜像来源

MAINTAINER DTSTACK \#声明镜像拥有者

RUN mkdir /dtstact
\#RUN后面接容器运行前需要执行的命令，由于Dockerfile文件不能超过127行，因此当命令较多时建议写到脚本中执行

ENTRYPOINT ping www.aliyun.com
\#开机启动命令，此处最后一个命令需要是可在前台持续执行的命令，否则容器后台运行时会因为命令执行完而退出。

构建镜像

docker build -t webcentos:v1 . \# . 是Dockerfile文件的路径，不能忽略

docker images \#查看是否创建成功

docker run -d webcentos:v1 \#后台运行容器

docker ps \#查看当前运行中的容器

docker ps -a \#查看所有容器，包括未运行中的

docker logs CONTAINER ID/IMAGE
\#如未查看到刚才运行的容器，则用容器id或者名字查看启动日志排错

docker commit fb2844b6c070 dtstackweb:v1 \#commit 后接容器id
和构建新镜像的名称和版本号。

docker images \#列出本地（已下载的和本地创建的）镜像

docker push \#将镜像推送至远程仓库，默认为 Docker Hub

将镜像推送到registry

docker login --username=dtstack_plus registry.cn-shanghai.aliyuncs.com
\#执行后输入镜像仓库密码

docker tag [ImageId]
registry.cn-shanghai.aliyuncs.com/dtstack123/test:[镜像版本号]

docker push registry.cn-shanghai.aliyuncs.com/dtstack123/test:[镜像版本号]

在镜像仓库能查看到镜像版本信息则说明push成功。

其中ImageId和镜像版本号请您根据自己的镜像信息进行填写。

PS：开启路由转发功能，让容器实例上网  
echo 1 \> /proc/sys/net/ipv4/ip_forward
