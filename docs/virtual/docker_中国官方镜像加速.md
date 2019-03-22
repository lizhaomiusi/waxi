Docker 中国官方镜像加速可通过

registry.docker-cn.com
访问。该镜像库只包含流行的公有镜像。私有镜像仍需要从美国镜像库中拉取。

第一种  
您可以使用以下命令直接从该镜像加速地址进行拉取：  
docker pull registry.docker-cn.com/myname/myrepo:mytag

例如:  
docker pull registry.docker-cn.com/library/ubuntu:16.04  
注: 除非您修改了 Docker 守护进程的 \`--registry-mirror\` 参数 (见下文),
否则您将需要完整地指定官方镜像的名称。例如，library/ubuntu、library/redis、library/nginx。

使用 --registry-mirror 配置 Docker 守护进程  
您可以配置 Docker 守护进程默认使用 Docker
官方镜像加速。这样您可以默认通过官方镜像加速拉取镜像，而无需在每次拉取时指定
registry.docker-cn.com。  
您可以在 Docker 守护进程启动时传入 --registry-mirror 参数：  
docker --registry-mirror=https://registry.docker-cn.com daemon

第二种

1. 安装／升级Docker客户端

推荐安装1.10.0以上版本的Docker客户端，参考文档 docker-ce

2. 配置镜像加速器

针对Docker客户端版本大于 1.10.0 的用户

您可以通过修改daemon配置文件/etc/docker/daemon.json来使用加速器

sudo mkdir -p /etc/docker

sudo tee /etc/docker/daemon.json \<\<-'EOF'

{

"registry-mirrors": ["https://f4pj62jg.mirror.aliyuncs.com"]

}

EOF

sudo systemctl daemon-reload

sudo systemctl restart docker

使用中科大的docker源  
vi /etc/docker/daemon.json  
{  
"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]  
}

其他源

https://registry.docker-cn.com  
http://hub-mirror.c.163.com  
https://docker.mirrors.ustc.edu.cn
