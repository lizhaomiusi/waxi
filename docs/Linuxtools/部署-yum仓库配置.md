部署-yum仓库配置

环境  
[root\@docker yum.repos.d]\# cat /etc/redhat-release

CentOS Linux release 7.4.1708

\# 修改yum安装软件保存rpm包，默认删除

cat /etc/yum.conf

[main]

cachedir=/var/cache/yum/\$basearch/\$releasever \# 存储路径

keepcache=1 \# 0修改为1，保存包

\# 搭建web文件服务

yum install httpd -y

\# 链接仓库目录到nginx网站根目录  
ln -s /var/cache/yum /var/www/html/yum  
重启服务  
systemctl restart httpd.service

systemctl enable httpd.service

\# 安装createrepo存储库软件  
yum -y install createrepo

\# 初始化repodata索引文件 把网站根目录创建为仓库目录 根目录下执行  
createrepo -pdo /var/www/html/yum/ /var/www/html/yum/  
  
\# 每加入一个rpm包就要更新一下。  
createrepo --update /var/www/html/yum/

\# 客户端配置

mkdir /etc/yum.repos.d/bak

mv /etc/yum.repos.d/\*.repo /etc/yum.repos.d/bak/  
cat \> /etc/yum.repos.d/local.repo \<\< EOF  
[local]  
name=local  
baseurl=http://10.1.2.70/yum/  
enable=1  
gpgcheck=0  
EOF  
  
\# 如果仓库更新，客户端需要生成缓存一下，如果永久，备份repo文件，清理和生成缓存  
yum clean all  
yum makecache  
  
\# 查询yum库  
yum repolist  
yum list

\# PS：\#临时使用内网yum源，指定myrpm库  
yum --enablerepo=local --disablerepo=base,extras,updates,epel list  
  
\# 想永久就需要修改配置文件将默认的repo文件关闭，或者备份  
[root\@oldboy \~]\# vi /etc/yum.repos.d/CentOS-Base.repo  
\# 在每一个启动的源加上  
\# enabled=0 \#改为1就启用，没有此参数也是启用。  
[base]  
…………  
enabled=0  
  
[updates]  
…………  
enabled=0  
\# 还有其他开启的仓库就使用这个办法关闭。

\# yum-plugin-downloadonly，下载rpm包不安装，要依赖一起下载配合下面命令  
yum install yum-plugin-downloadonly -y

yum install -y --downloadonly --downloaddir=/opt/yum/nginx nginx

\# --downloadonly参数也会同时将所依赖的rpm一起下载下来，可下载多个

\# --downloaddir用来指定下载的路径，默认保存在/var/cache/yum/ 的
rhel-{arch}-channel/packageslocation 目录  
\# 通过rpm -ivh命令或者yum localinstall可以在没有网的情况下方便的安装。

\# yumdownloader，下载rpm包不安装，要依赖一起下载配合下面命令

\# yumdownloader在软件包 yum-utils 里面。先安装 yum-utils ：

yum install yum-utils -y

\# 查看 yum-utils 软件包有没有 yumdownloader，如果有输出代表可用：

rpm -ql yum-utils \|grep yumdownloader

yumdownloader nginx --resolve --destdir=/opt/yum/

\# 如果要下载依赖加上"--resolve"参数

\# 如果要指定下载目录。加上"--destdir"参数，默认保存在当前目录

不像 Downloadonly 插件，Yumdownload 可以下载一组相关的软件包。

yumdownloader "\@Development Tools" --resolve --destdir=/opt/yum/
