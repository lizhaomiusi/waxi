部署-EPEL源_yum源

是由 Fedora 社区打造，为 RHEL 及衍生发行版如
CentOS等提供高质量软件包的项目。装上了 EPEL，就像在 Fedora 上一样，可以通过 yum
install
软件包名，即可安装很多以前需要编译安装的软件、常用的软件或一些比较流行的软件，比如现在流行的nginx、htop、ncdu、vnstat等等，都可以使用EPEL很方便的安装更新。  
目前可以直接通过执行命令：  
  
yum install epel-release -y

yum install wget -y  
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.163.com/.help/CentOS7-Base-163.repo  
yum clean all  
yum makecache

直接进行安装，如果此命令无法安装可以尝试以下方法  
----安装EPEL 阿里云源  
1、备份(如有配置其他epel源)  
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup  
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup

2、下载新repo 到/etc/yum.repos.d/  
epel(RHEL 7)  
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo  
epel(RHEL 6)  
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo  
epel(RHEL 5)  
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo  
CentOS/RHEL 5 ：  
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm  
CentOS/RHEL 6 ：  
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm  
CentOS/RHEL 7 ：  
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

国内yum源的安装(163，阿里云，epel)

163镜像源  
第一步：备份你的原镜像文件，以免出错后可以恢复。  
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup  
CentOS 5  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.163.com/.help/CentOS5-Base-163.repo  
CentOS 6  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.163.com/.help/CentOS6-Base-163.repo  
CentOS 7  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.163.com/.help/CentOS7-Base-163.repo

生成缓存  
yum clean all  
yum makecache  
  
阿里云镜像源  
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup  
CentOS 5  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-5.repo  
curl -o /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-5.repo  
CentOS 6  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-6.repo  
curl -o /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-6.repo  
CentOS 7  
wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-7.repo  
curl -o /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-7.repo

生成缓存  
yum clean all  
yum makecache

\---  
PS：yum 修改安装rpm包本地不清除  
[root\@localhost media]\# cat /etc/yum.conf  
[main]  
cachedir=/var/cache/yum/\$basearch/\$releasever \# rpm包缓存目录  
keepcache=0 \# 是否保存rpm包 1保存 0不保存  
debuglevel=2 \# 日志级别，0-10  
logfile=/var/log/yum.log \# 日志文件  
exactarch=1  
obsoletes=1  
gpgcheck=1  
plugins=1  
  
sed -i 's\#keepcache=0\#keepcache=1\#g' /etc/yum.conf  
grep keepcache /etc/yum.conf  
keepcache=1 \# rpm包下载后不清除  
/var/cache/yum/base/packages/ \# rpm包默认存放路径

配置本地yum源  
https://www.cnblogs.com/wangg-mail/p/4418350.html  
https://www.jianshu.com/p/58c392a50f37  
备份原yum源 挂载光盘 创建.repo文件  
mkdir /mnt/cdrom  
mount -o loop /dev/cdrom /mnt/cdrom/  
编写repo文件并指向镜像的挂载目录  
cat \> /etc/yum.repos.d/local.repo \<\<EOF  
[local]  
name=local  
baseurl=file:///mnt/cdrom  
gpgcheck=0  
enabled=1  
priority=1  
EOF  
\#清除缓存  
yum clean all  
\#把yum源缓存到本地，加快软件的搜索好安装速度  
yum makecache  
\#列出了3780个包  
yum list  
  
修改Yum源的优先级  
  
当既有本地Yum源又有163源的时候，我们在装软件包的时候当然希望先用本地的Yum源去安装，本地找不到可用的包时再使用163源去安装软件,这里就涉及到了优先级的问题，  
Yum提供的插件yum-plugin-priorities.noarch可以解决这个问题  
查看系统是否安装了优先级的插件  
[root\@kangvcar \~]\# rpm -qa \| grep yum-plugin-  
yum-plugin-fastestmirror-1.1.31-34.el7.noarch  
//这里看到没有安装  
yum-plugin-priorities.noarch这个插件  
[root\@kangvcar \~]\# yum search yum-plugin-priorities  
//用search查看是否有此插件可用  
Loaded plugins: fastestmirror  
Loading mirror speeds from cached hostfile  
\* base: mirrors.aliyun.com  
\* extras: mirrors.aliyun.com  
\* updates: mirrors.aliyun.com  
====================================================== N/S matched:
yum-plugin-priorities =======================================================  
yum-plugin-priorities.noarch : plugin to give priorities to packages from
different repos  
  
安装yum-plugin-priorities.noarch插件  
[root\@kangvcar \~]\# yum -y install yum-plugin-priorities.noarch  
查看插件是否启用  
[root\@kangvcar \~]\# cat /etc/yum/pluginconf.d/priorities.conf  
[main]  
enabled = 1  
//1为启用；0为禁用  
修改本地Yum源优先使用  
[root\@kangvcar \~]\# ll /etc/yum.repos.d/  
total 8  
-rw-r--r--. 1 root root 2573 May 15 2015 CentOS-Base.repo  
-rw-r--r--. 1 root root 67 Jun 20 06:04 local.repo  
//有两个repo文件  
[root\@kangvcar \~]\# vi /etc/yum.repos.d/local.repo  
[local]  
name=local  
baseurl=file:///opt/centos  
enabled=1  
gpgcheck=0  
priority=1  
//在原基础上加入priority=1 ；数字越小优先级越高  
//可以继续修改其他源的priority值，经测试仅配置本地源的优先级为priority=1就会优先使用本地源了  
测试
