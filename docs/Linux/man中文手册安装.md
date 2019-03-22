linux中文man手册安装  
1.下载源码  
  
源码网址 https://src.fedoraproject.org/repo/pkgs/man-pages-zh-CN/  
\# 下载源码  
wget
https://src.fedoraproject.org/repo/pkgs/man-pages-zh-CN/v1.5.2.tar.gz/1bbdc4f32272df0b95146518b27bf4be/v1.5.2.tar.gz  
or  
wget
https://src.fedoraproject.org/repo/pkgs/man-pages-zh-CN/manpages-zh-1.5.1.tar.gz/13275fd039de8788b15151c896150bc4/manpages-zh-1.5.1.tar.gz  
\# 解压  
tar -zxvf manpages-zh-1.5.1.tar.gz  
\# 安装  
cd manpages-zh-1.5.1  
./configure --prefix=/usr/local/zhman --disable-zhtw  
make && make install  
\# 最后配置  
\# 为了不抵消man，我们新建cman命令作为中文查询  
cd \~  
echo "alias cman='man -M /usr/local/zhman/share/man/zh_CN' " \>\>.bash_profile  
source .bash_profile  
\# 测试是否可用  
cman vim  
\# 正常情况下，应该能用了。但是可能有不能用。出现错误，我曾经遇到过。  
\# 以上是在centos7下配置。centos6差不多。
