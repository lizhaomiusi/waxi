安装docker源  
curl https://download.docker.com/linux/centos/docker-ce.repo -o
/etc/yum.repos.d/docker-ce.repo

rpm包下载  
wget
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm  
  
如果慢 \<https://www.docker-cn.com/registry-mirror\>  
  
1、部署Docker

\# CentOS 6  
rpm -iUvh
http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm  
yum update -y  
yum -y install docker-io  
service docker start  
chkconfig docker on  
  
\# CentOS 7  
curl -sSL https://get.docker.com/ \| sh  
systemctl start docker  
systemctl enable docker.service
