docker常用命令

https://www.toutiao.com/i6592203691896340999/  
https://help.aliyun.com/document_detail/60742.html  
https://www.cnblogs.com/wglIT/p/6915659.html  
http://www.docker.org.cn/dockerppt/106.html  
  
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh \| sh -s
http://d552c9b5.m.daocloud.io \#配置拉取源

查询创建  
docker info \#检查是否正确安装  
docker search mysql \#查询镜像  
docker pull BusyBox \#拉取镜像 BusyBox是一个最小的Linux系统

查询操作  
docker images \#查看本地镜像  
docker ps \#查看当前正在运行的容器  
docker ps -a \#查看所有容器的状态  
docker start/stop/name/restart id \#启动/停止某个容器  
docker cp d2e367c4ff5f（容器 ID）:/etc/nginx/nginx.conf /home/zk
\#从容器中拷贝文件到系统  
删除  
docker rm id/name \#删除某个容器需要先停止  
docker rmi id/name \#删除某个镜像  
运行  
docker exec -ti id
\#启动一个伪终端以交互式的方式进入某个容器（使用exit退出后容器不停止运行）  
docker attach id \#进入某个容器(使用exit退出后容器也跟着停止运行)  
  
运行容器  
docker run [OPTIONS] IMAGE[:TAG] [COMMAND] [ARG...] \#运行一个容器  
OPTIONS说明：  
-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；  
-d: 后台运行容器，并返回容器ID；  
-i: 以交互模式运行容器，通常与 -t 同时使用；  
-p: 端口映射，格式为：主机(宿主)端口:容器端口  
-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；  
--name="nginx-lb": 为容器指定一个名称；  
--dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致；  
--dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；  
-h "mars": 指定容器的hostname；  
-e username="ritchie": 设置环境变量；  
--env-file=[]: 从指定文件读入环境变量；  
--cpuset="0-2" or --cpuset="0,1,2": 绑定容器到指定CPU运行；  
-m :设置容器使用内存最大值；  
--net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container:
四种类型；  
--link=[]: 添加链接到另一个容器；  
--expose=[]: 开放一个端口或一组端口；  
  
docker run -dit -p 2222:22 --name test soar/centos:7.1
\#以镜像soar/centos:7.1创建名为test的容器，并以后台模式运行，并做端口映射到宿主机2222端口，P参数重启容器宿主机端口会发生改变  
  
docker run --name first-mysql -p 3306:3306 -e MYSQL\\_ROOT\\_PASSWORD=123456 -d
mysql \#run运行 --name容器名字 -p指定端口 -e指定配置信息 为mysql的登陆信息
-d后台运行 mysql镜像名字  
  
docker run --name test -ti ubuntu /bin/bash
\#复制ubuntu容器并且重命名为test且运行，然后以伪终端交互式方式进入容器，运行bash  
创建docker镜像  
docker build -t soar/centos:7.1
\#通过当前目录下的Dockerfile创建一个名为soar/centos:7.1的镜像  
  
docker run -dit -P -v /home/myapp:/usr/share/nginx/myapp -v
/home/zk/nginx.conf:/etc/nginx/nginx.conf 3f8a4339aadd（镜像ID）
将文件挂载到容器中；其中“：”前面是系统的地址，后面是容器内的地址，容器中没有可以创建文件和目录，容器中有的话直接替换。  
  
docker run --name wgl_centos_daemon -d centos /bin/sh -c "while true;do echo
hello world;sleep 3;done" \#在后台运行，只返回容器ID，-d 在后台运行  
  
  
docker \# docker 命令帮助  
  
Commands:  
attach Attach to a running container \# 当前 shell 下 attach 连接指定运行镜像  
build Build an image from a Dockerfile \# 通过 Dockerfile 定制镜像  
commit Create a new image from a container's changes \# 提交当前容器为新的镜像  
cp Copy files/folders from the containers filesystem to the host path

\# 从容器中拷贝指定文件或者目录到宿主机中  
create Create a new container \# 创建一个新的容器，同 run，但不启动容器  
diff Inspect changes on a container's filesystem \# 查看 docker 容器变化  
events Get real time events from the server \# 从 docker 服务获取容器实时事件  
exec Run a command in an existing container \# 在已存在的容器上运行命令  
export Stream the contents of a container as a tar archive

\# 导出容器的内容流作为一个 tar 归档文件[对应 import ]  
history Show the history of an image \# 展示一个镜像形成历史  
images List images \# 列出系统当前镜像  
import Create a new filesystem image from the contents of a tarball

\# 从tar包中的内容创建一个新的文件系统映像[对应 export]  
info Display system-wide information \# 显示系统相关信息  
inspect Return low-level information on a container \# 查看容器详细信息  
kill Kill a running container \# kill 指定 docker 容器  
load Load an image from a tar archive \# 从一个 tar 包中加载一个镜像[对应 save]  
login Register or Login to the docker registry server

\# 注册或者登陆一个 docker 源服务器  
logout Log out from a Docker registry server \# 从当前 Docker registry 退出  
logs Fetch the logs of a container \# 输出当前容器日志信息  
port Lookup the public-facing port which is NAT-ed to PRIVATE_PORT

\# 查看映射端口对应的容器内部源端口  
pause Pause all processes within a container \# 暂停容器  
ps List containers \# 列出容器列表  
pull Pull an image or a repository from the docker registry server

\# 从docker镜像源服务器拉取指定镜像或者库镜像  
push Push an image or a repository to the docker registry server

\# 推送指定镜像或者库镜像至docker源服务器  
restart Restart a running container \# 重启运行的容器  
rm Remove one or more containers \# 移除一个或者多个容器  
rmi Remove one or more images

\# 移除一个或多个镜像[无容器使用该镜像才可删除，否则需删除相关容器才可继续或 -f
强制删除]  
run Run a command in a new container

\# 创建一个新的容器并运行一个命令  
save Save an image to a tar archive \# 保存一个镜像为一个 tar 包[对应 load]  
search Search for an image on the Docker Hub \# 在 docker hub 中搜索镜像  
start Start a stopped containers \# 启动容器  
stop Stop a running containers \# 停止容器  
tag Tag an image into a repository \# 给源中镜像打标签  
top Lookup the running processes of a container \# 查看容器中运行的进程信息  
unpause Unpause a paused container \# 取消暂停容器  
version Show the docker version information \# 查看 docker 版本号  
wait Block until a container stops, then print its exit code

\# 截取容器停止时的退出状态值  
Run 'docker COMMAND --help' for more information on a command.
