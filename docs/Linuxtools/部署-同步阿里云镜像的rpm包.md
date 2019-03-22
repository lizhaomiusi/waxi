部署-同步阿里云镜像的rpm包

Centos7下自建yum源并同步阿里云镜像的rpm包

同步相关包

1、设置阿里云镜像为本地yum源

yum install wget -y  
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-7.repo  
yum clean all

yum makecache

2、选择指定仓库标识作为本地yum源

yum repolist \# 查看yum仓库标识

3、将阿里云中的epel源同步到本地/opt/yum/centos/7/中；第一次同步是时间可能较长，我这里有9911个rpm包。

reposync命令是一个python脚本。需要yum install yum-utils包。

reposync -r base -p /opt/yum/centos/7/

reposync -r extras -p /opt/yum/centos/7/

reposync -r updates -p /opt/yum/centos/7/

脚本自动更新

cat \> /root/yum-update.sh \<\< \\EOF

\#!/bin/bash

datetime=\`date +"%Y-%m-%d"\`

exec \> /var/log/centosrepo.log

reposync -d -r base -p /opt/yum/centos/7/

\# 同步镜像源

if [ \$? -eq 0 ];then

createrepo --update /opt/yum/centos/7/x86_64

\#每次添加新的rpm时,必须更新索引信息

echo "SUCESS: \$datetime epel update successful"

else

echo "ERROR: \$datetime epel update failed"

fi

EOF

定时任务：每周二凌晨三点同步yum源

crontab -e

0 2 \* \* 3 /bin/bash /root/yum-update.sh

4、更新索引

createrepo --update /opt/yum/centos/7/x86_64/

5、清理缓存数据

yum clean all

yum makecache

6、编写repo文件

vim /etc/yum.repos.d/feiyu-7.repo内容如下

[feiyu]

name=centos-feiyu

baseurl=http://192.168.0.27/yum

enabled=1

gpgcheck=0
