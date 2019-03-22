实战shell备份  
  
\#!/bin/bash  
\#  
echo "备份中"  
sleep 2  
cp -av /etc/ /root/etc\`date +%F\`  
echo "备份完成"  
  
跟参数复制文件  
[root\@centos6 \~]\# cat copy.sh  
\#!/bin/bash  
echo "start..."  
cp -v \$\* /root/bin/  
echo "copy stop"
