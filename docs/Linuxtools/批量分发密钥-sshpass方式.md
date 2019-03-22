sshpass工具

https://www.cnblogs.com/paul8339/p/7641413.html  
  
\# 非交互式发送密码  
开始安装sshpass免交互工具并进行SSH-key的批量分发  
下载epel源并更新yum仓库  
[root\@m01 \~]\# wget -O /etc/yum.repos.d/epel.repo
http://mirrors.aliyun.com/repo/epel-6.repo  
[root\@m01 \~]\# yum -y clean all  
[root\@m01 \~]\# yum makecache  
  
安装sshpass工具  
yum -y install sshpass  
\# 免交互创建密钥对  
ssh-keygen -t rsa -P '' -f \~/.ssh/id_rsa \>/dev/null 2\>&1  
  
\#免交户方式分发公钥  
sshpass -p "qqq111" ssh-copy-id -i \~/.ssh/id_rsa.pub "-o
StrictHostKeyChecking=no root\@10.1.2.62" \>/dev/null 2\>&1  
sshpass：专为ssh连接服务的免交户工具  
-p ：指定登录的密码  
ssh-copy-id：自动分发公钥的工具  
-i：指定公钥路径  
-o StrictHostKeyChecking=no
:不进行对方主机信息的写入（第一次ssh连接会在know_hosts文件里记录）  
测试ssh密钥认证情况

使用脚本实现批量给服务器发送密钥

yum install sshpass -y

\#!/bin/bash  
passwd=qqq111  
IP_ADDR="61 62 63"  
. /etc/init.d/functions  
\# 一键生成密钥  
if ! [ -f \~/.ssh/id_dsa.pub ];then  
ssh-keygen -t dsa -P '' -f \~/.ssh/id_dsa \>/dev/null 2\>&1  
echo -e "\\033[32m======Local=========\\033[0m"  
action "Generate the key!" /bin/true  
fi  
\# 批量发送密钥  
for i in \$IP_ADDR;do  
sshpass -p\$passwd ssh-copy-id -i /root/.ssh/id_dsa.pub "-o
StrictHostKeyChecking=no 192.168.21.\${i}" \>/dev/null 2\>&1  
  
if [ \$? == 0 ];then  
echo -e "\\033[32m=========\`ssh 192.168.21.\$i hostname\`==========\\033[0m"  
action "发送成功!!!" /bin/true  
else  
echo -e "\\033[31m======192.168.21.\$i=======\\033[0m"  
action "发送失败!!!" /bin/false  
fi  
done  
  
  
第二种脚本

\#!/bin/bash  
\# author:Mr.chen  
\# 2017-3-14  
\# description:SSH密钥批量分发  
  
User=root  
passWord=\#\#Linux登录密码  
  
function YumBuild(){  
  
echo "正在安装epel源yum仓库，请稍后..."  
cd /etc/yum.repos.d/ &&\\  
[ -d bak ] \|\| mkdir bak  
[ \`find ./\*.\* -type f \| wc -l\` -gt 0 ] && find ./\*.\* -type f \| xargs -i
mv {} bak/  
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
&\>/dev/null  
yum -y clean all &\>/dev/null  
yum makecache &\>/dev/null  
}  
  
echo "正在进行网络连接测试,请稍后..."  
ping www.baidu.com -c2 \>/dev/null \|\|(echo
"无法连同外网，本脚本运行环境必须和外网相连！" && exit)  
[ \$\# -eq 0 ] && echo "没有参数！格式为：sh \$0 参数1...n" && exit  
rpm -q sshpass &\>/dev/null \|\| yum -y install sshpass &\>/dev/null  
if [ \$? -gt 0 ];then  
YumBuild  
yum -y install sshpass &\>/dev/null \|\| (echo "sshpass build error！" && exit)  
fi  
[ -d \~/.ssh ] \|\| mkdir \~/.ssh;chmod 700 \~/.ssh  
echo "正在创建密钥对...."  
rm -rf \~/.ssh/id_dsa \~/.ssh/id_dsa.pub  
ssh-keygen -t dsa -f \~/.ssh/id_dsa -P "" &\>/dev/null  
for ip in \$\*  
do  
ping \$ip -c1 &\>/dev/null  
if [ \$? -gt 0 ];then  
echo "\$ip无法ping通请检查网络"  
continue  
fi  
sshpass -p "\$passWord" ssh-copy-id -i \~/.ssh/id_dsa.pub "-o
StrictHostKeyChecking=no \${User}\@\$ip" &\>/dev/null  
echo "\$ip 密钥分发成功"  
done
