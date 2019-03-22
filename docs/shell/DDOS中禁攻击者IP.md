awk ‘{print \$1}’/root/access2018.log \|sort \|uniq -c \|sort -rn k1  
9 59.33.26.105  
8 124.115.4.18  
3 123.122.65.226  
  
\#!/bin/bash  
\#做判断 有没有跟参数 如果没有提示  
if [ \$\# -ne 1 ];then  
echo "USAGE:\$0 ARG"  
exit 1  
fi  
\#查询IP次数  
awk '{print \$1}'/root/access2018.log \|sort \|uniq -c \|sort -rn k1
\>/tmp/tmp.log  
exec \</tmp/tmp.log  
while read line  
do  
\#取IP  
ip=\`echo \$line \|awk '{print \$2}'\`  
\#如果IP次数小于10并且 在防火墙内不存在则加入防火墙  
if [ \`echo \$line \|awk '{print \$1}'\` -gt 10 -a \`iptables -L -n \|grep
"\$ip" \|wc -l\` -lt 1 ];then  
iptables -I INPUT -s \$ip -j DROP  
\#把IP按天保存下载 后期清除  
echo \$ip \>\>/tmp/ip_\$(date +%F).log  
fi  
done  
del(){
