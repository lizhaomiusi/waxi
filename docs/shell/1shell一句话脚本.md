\---  
  
https://segmentfault.com/a/1190000005720358

\# sed和awk命令  
https://www.cnblogs.com/iOS-mt/p/7156124.html  
  
---  
打印进程  
ps -ef \| awk -v OFS="\\n" '{ for (i=8;i\<=NF;i++) line = (line ? line FS : "")
\$i; print NR ":", \$1, \$2, \$7, line, ""; line = "" }'  
---  
为备份文件生成md5值

find /backup/ -type f -name "\*\$(date +%F).tar.gz" \|xargs md5sum  
---  
\# 取20\~30行

cat filename \|head -n 30 \|tail -n +20

head -30 /tmp/file.log\|tail -11

sed -n ‘20,30p‘ /tmp/file.log

sed ‘20,30!d‘ /tmp/file.log

awk ‘NR==20,NR==30‘ /tmp/file.log

awk ‘NR\>=20 && NR\<=30‘ /tmp/file.log

grep -n "" /tmp/file.log \|grep -A 10 "\^20:"

grep -n "" /tmp/file.log \|grep -B 10 "\^30:"

grep -n "" /tmp/file.log \|grep -C 5 "\^25:"

\---  
统计.h文件和.cpp文件行数:  
find -name "\*[.h\|.cpp\|.sh]" -type f \| xargs cat \| grep -v \^\$\| wc -l  
---  
统计当前目录下所有cpp文件行数并过滤空行：  
find . -name "\*.cpp" \| xargs cat \| grep -v \^\$\| wc -l  
\^\$是正则表达式，\^是以匹配开头，\$是匹配结尾，所以\^\$是匹配一个空行。  
---  
统计当前目录下所有cpp文件行数：  
find . -name "\*.cpp" \| xargs cat \| wc -l  
---  
\#取外网IP  
\#!/bin/bash  
curl -s ipecho.net/plain;echo  
27.17.26.205  
---  
统计80端口连接数  
netstat -nat\|grep -i "80"\|wc -l  
---  
统计httpd协议连接数  
ps -ef\|grep httpd\|wc -l  
---  
统计已连接上的，状态为established  
netstat -na\|grep ESTABLISHED\|wc -l  
---  
查出哪个IP地址连接最多,将其封了.  
netstat -na\|grep ESTABLISHED\|awk {print \$5}\|awk -F: {print \$1}\|sort\|uniq
-c\|sort -r +0n  
netstat -na\|grep SYN\|awk {print \$5}\|awk -F: {print \$1}\|sort\|uniq -c\|sort
-r +0n  
---  
显示每个ip的连接数  
netstat -ntu \| awk '{print \$5}' \| cut -d: -f1 \| sort \| uniq -c \| sort -n  
---  
查看当前网络连接数  
netstat -n \| awk '/\^tcp/ {++S[\$NF]} END {for(a in S) print a, S[a]}'  
TCP连接状态详解  
LISTEN： 侦听来自远方的TCP端口的连接请求  
SYN-SENT： 再发送连接请求后等待匹配的连接请求  
SYN-RECEIVED：再收到和发送一个连接请求后等待对方对连接请求的确认  
ESTABLISHED： 代表一个打开的连接  
FIN-WAIT-1： 等待远程TCP连接中断请求，或先前的连接中断请求的确认  
FIN-WAIT-2： 从远程TCP等待连接中断请求  
CLOSE-WAIT： 等待从本地用户发来的连接中断请求  
CLOSING： 等待远程TCP对连接中断的确认  
LAST-ACK： 等待原来的发向远程TCP的连接中断请求的确认  
TIME-WAIT： 等待足够的时间以确保远程TCP接收到连接中断请求的确认  
CLOSED： 没有任何连接状态  
---  
模拟linux登录shell  
\#!/bin/bash  
echo -n "login:"  
read name  
echo -n "password:"  
read passwd  
if  
[ \$name = "cht" -a \$passwd = "abc" ];then  
echo "the host and password is right!"  
else  
echo "input is error!"  
fi  
---  
比较两个数大小  
\#!/bin/bash  
echo "please enter two number"  
read a  
read b  
if test \$a -eq \$b  
then echo "NO.1 = NO.2"  
elif test \$a -gt \$b  
then echo "NO.1 \> NO.2"  
else echo "NO.1 \< NO.2"  
fi  
---  
查找/root/目录下是否存在该文件  
\#!/bin/bash  
echo "enter a file name:"  
read a  
if test -e /root/\$a  
then echo "the file is exist!"  
else echo "the file is not exist!"  
fi  
---  
删除当前目录下大小为0的文件  
\#!/bin/bash  
for filename in \`ls\`  
do  
if test -d \$filename  
then b=0  
else  
a=\$(ls -l \$filename \| awk '{ print \$5 }')  
if test \$a -eq 0  
then rm \$filename  
fi  
fi  
done  
---  
测试IP地址  
\#!/bin/bash  
for i in 1 2 3 4 5 6 7 8 9  
do  
echo "the number of \$i computer is "  
ping -c 1 192.168.0.\$i  
done  
---  
如果test.log的大小大于0，那么将/opt目录下的\*.tar.gz文件拷贝到当前目录下  
  
\#!/bin/sh  
a=2  
while name="test.log"  
do  
sleep 1  
b=\$(ls -l \$name \| awk '{print \$5}')  
if test \$b -gt \$a  
then \`cp /opt/\*.tar.gz .\`  
exit 0  
fi  
done  
---  
从0.sh中读取内容并打印  
  
\#!/bin/bash  
while read line  
do  
echo \$line  
done \< 0.sh  
---  
读取a.c中的内容并做加1运算  
\#!/bin/bash  
test -e a.c  
while read line  
do  
a=\$((\$line+1))  
done \< a.c  
echo \$a  
---  
普通无参数函数  
  
\#!/bin/bash  
p ()  
{  
echo "hello"  
}  
p  
---  
给函数传递参数  
\#!/bin/bash  
p_num ()  
{  
num=\$1  
echo \$num  
}  
for n in \$\@  
do  
p_num \$n  
done  
---  
创建文件夹  
\#!/bin/bash  
while :  
do  
echo "please input file's name:"  
read a  
if test -e /root/\$a  
then  
echo "the file is existing Please input new file name:"  
else  
mkdir \$a  
echo "you aye sussesful!"  
break  
fi  
done  
---  
获取本机IP地址  
\#!/bin/bash  
ifconfig \| grep "inet addr:" \| awk '{ print \$2 }'\| sed 's/addr://g'  
---  
查找最大文件  
\#!/bin/bash  
a=0  
for name in \*.\*  
do  
b=\$(ls -l \$name \| awk '{print \$5}')  
if test \$b -gt \$a  
then a=\$b  
namemax=\$name  
fi  
done  
echo "the max file is \$namemax"  
---  
查找当前网段内IP用户，重定向到ip.txt文件中  
\#!/bin/bash  
a=1  
while :  
do  
a=\$((\$a+1))  
if test \$a -gt 255  
then break  
else  
echo \$(ping -c 1 192.168.0.\$a \| grep "ttl" \| awk '{print \$4}'\| sed
's/://g')  
ip=\$(ping -c 1 192.168.0.\$a \| grep "ttl" \| awk '{print \$4}'\| sed 's/://g')  
echo \$ip \>\> ip.txt  
fi  
done  
---  
打印当前用户  
\#!/bin/bash  
echo "Current User is :"  
echo \$(ps \| grep "\$\$" \| awk '{print \$2}')  
---  
  
yes/no返回不同的结构  
\#!/bin/bash  
clear  
echo "enter [y/n]:"  
read a  
case \$a in  
y\|Y\|Yes\|YES) echo "you enter \$a"  
;;  
n\|N\|NO\|no) echo "you enter \$a"  
;;  
\*) echo "error"  
;;  
esac  
---  
  
内置命令的使用  
\#!/bin/bash  
clear  
echo "Hello, \$USER"  
echo "Today 's date id \`date\`"  
echo "the user is :"  
who  
echo "this is \`uname -s\`"  
echo "that's all folks! "  
---  
  
打印无密码用户  
\#!/bin/bash  
echo "No Password User are :"  
echo \$(cat /etc/shadow \| grep "!!" \| awk 'BEGIN { FS=":" }{print \$1}')  
---  
  
\# 查看指定端口占用情况  
lsof -i tcp:2181 \| grep -v COMMAND  
---  
\# 修改终端编码  
export LC_ALL=zh_CN.UTF-8  
---  
  
\# 查看系统支持的最大线程数  
cat /proc/sys/kernel/threads-max  
---  
  
\# shell取一天前的日期  
date -d "1 days ago" +"%Y-%m-%d"  
---  
  
\# 统计当前第一层目录下所有文件占用的空间大小  
du ./ -h --max-depth=1  
---  
  
\#随机生成数字  
[root\@centos6 \~]\# cat log.sh  
\#!/bin/bash  
num=\$[RANDOM%100-1]  
while :  
do  
read -p "随机生成了一个1-100的数，你猜：" ccc  
if [ \$ccc -eq \$num ];then  
echo "猜对了"  
break  
elif [ \$ccc -le \$num ];then  
echo "小了"  
else  
echo "大了"  
fi  
done  
获取随机8位字符串  
echo \$RANDOM \|md5sum \|cut -c 1-8  
openssl rand -base64 4  
cat /proc/sys/kernel/random/uuid \|cut -c 1-8  
获取随机8位数字  
echo \$RANDOM \|cksum \|cut -c 1-8  
openssl rand -base64 4 \|cksum \|cut -c 1-8  
date +%N \|cut -c 1-8  
  
从指定字符集合中生成随机字符串  
\#!/bin/bash  
MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\~!\@\#\$%\^&\*()_+="  
LENGTH="9"  
while [ "\${n:=1}" -le "\$LENGTH" ]  
do  
PASS="\$PASS\${MATRIX:\$((\$RANDOM%\${\#MATRIX})):1}"  
let n+=1  
done  
echo "\$PASS"  
exit 0  
---  
  
\#批量ping地址  
\#!/bin/bash  
for i in {100..254}  
do  
ping -c2 -i0.3 -w1 192.168.10.\$i &\>/dev/null  
if [ \$? -eq 0 ];then  
echo "192.168.10.\$i is up"  
else  
echo "192.168.10.\$i is down"  
fi  
done  
---  
  
\#统计用户和UID 并统计  
cat /etc/passwd \|awk -F':' '{print "hello "\$1" \| your UID is"\$3}END{print
"Users: "NR}'  
---  
  
\#查询用户是否存在  
while :  
do  
read -p "请输入用户名(q退出):" user \#定义user为变量  
[[ "\$user" = "q" ]] \|\| [[ "\$user" = "quit" ]] && break \#break跳出死循环  
[[ -z \$user ]] && continue \#判断值是否为空 则跳过下面语句  
id \$user &\>/dev/null  
[[ \$? = 0 ]] && cat /etc/passwd \|grep "\^\$user" \|awk -F '[:]' '{print
\$3,\$NF}' \|\| echo "用户不存在 请重新输入" \#做判断 如果存在 就过滤 否则就echo  
done  
---  
  
\#统计IP来自哪里 \#统计重复 排序 -c去重并计数 -nr在从大到小逆序排序  
cat suiji.log \|sort \|uniq -c \|sort -nr \|head -5  
log=2000.log  
cat \$log \|awk '{print \$1}' \|sort \|uniq -c \|sort -nr \|head -5  
ip=\`cat \$log \|awk '{print \$1]' \|sort \|uniq -c \|sort -nr \|head -5 \|awk
'{print \$2}'\`  
for i in \$ip  
do  
address=\`curl ip.cn?ip=\$i 2\>/dev/null\`  
echo \$address  
done  
---  
  
\#计算  
\#!/bin/bash  
a=\$1  
b=\$2  
echo a+b=\$((\$a+\$b))  
echo a-b=\$((\$a-\$b))  
echo a\*b=\$((\$a\*\$b))  
echo a/b=\$((\$a/\$b))  
echo a%b=\$((\$a%\$b))  
echo a\*\*b=\$((\$a\*\*\$b))  
  
---  
  
A=5  
B=6  
echo \$((\$A+\$B)) \# 方法 2  
echo \$[\$A+\$B] \# 方法 3  
expr \$A + \$B \# 方法 4  
echo \$A+\$B \| bc \# 方法 5  
awk 'BEGIN{print '"\$A"'+'"\$B"'}' \# 方法 6  
  
---  
  
\#计算100总和  
\#!/bin/bash  
sum=0  
for i in \`seq 100\`  
do  
sum=\$[i+sum]  
done  
echo "总和为:\$sum"  
---  
  
\#计算平均值 M的平均值  
[root\@centos6 \~]\# cat dsd.log  
jack F 90  
tom M 70  
jerry F 99  
lily M 80  
  
\#!/bin/bash  
a=\`cat dsd.log \|grep '\\\<M\\\>' \|awk '{print \$3}'\`  
for i in \$a  
do  
s=\$((\$i+s))  
n=\$((\$n+1))  
done  
echo "\$((\$s/\$n))"  
---  
  
\#
使用命令调换passwd文件里root位置和/bin/bash位置？即将所有的第一列和最后一列位置调换？  
例：  
默认：root:x:0:0:root:/root:/bin/bash  
修改后：/bin/bash:x:0:0:root:/root:root  
[root\@lo oldboy]\# awk -F ":" 'NR{print
\$7":"\$2":"\$3":"\$4":"\$1":"\$6":"\$5}' /etc/passwd  
用sed互换  
sed -nr 's\#([\^:]+)(:.\*:)(/.\*\$)\#\\3\\2\\1\#gp' /etc/passwd \#
\\3匹配不以:开头的 \\2匹配:.\*： \\1匹配/结尾的  
---  
  
\# awk取passwd文件的第10行到20行的第三列重定向到/tmp/oldboy/test.txt文件里。  
[root\@lo oldboy]\# awk -F ":" 'NR\>9 && NR\<21{print \$3}' passwd
\>/tmp/oldboy/test.txt  
---  
  
\# 删除/tmp/oldboy/下除passwd以外的其他文件  
[root\@lo oldboy]\# find /tmp/oldboy -type f ! -name "passwd"\|xargs rm -f  
---  
  
\# 如何过滤出已知当前目录下oldboy中的所有一级文件夹  
[root\@lo tmp]\# ll\|grep \^d  
drwxr-xr-x. 2 root root 4096 Apr 25 01:15 oldboy  
[root\@lo tmp]\# ls -Fl\|grep /  
drwxr-xr-x. 2 root root 4096 Apr 25 01:32 a/  
drwxr-xr-x. 2 root root 4096 Apr 25 01:15 oldboy/  
[root\@lo tmp]\# find ./ -type d  
./  
./.ICE-unix  
./oldboy  
./a  
[root\@lo tmp]\# find ./ -type d ! -name "."  
./.ICE-unix  
./oldboy  
./a  
[root\@lo tmp]\# ls -dl \*/  
drwxr-xr-x. 2 root root 4096 Apr 25 01:32 a/  
drwxr-xr-x. 2 root root 4096 Apr 25 01:15 oldboy/  
[root\@lo tmp]\# ls -l\|sed -n '/\^d/p'  
drwxr-xr-x. 2 root root 4096 Apr 25 01:32 a  
drwxr-xr-x. 2 root root 4096 Apr 25 01:15 oldboy  
---  
  
\# 设置别名 设置grep过滤项自带颜色  
[root\@lo etc]\# vi /etc/profile 编辑别名  
alias grep='grep --color=auto' 添加该项目  
[root\@lo etc]\# source /etc/profile 使修改项目生效  
---  
  
\# 删除当前目录下的所有修改时间在7天之前的log文件  
-mtime修改时间  
[root\@lo oldboy]\# for n in \`seq 14\`  
\> do  
\> date -s "04/0\$n/13"  
\> touch access_www_\`(date +%F)\`.log  
\> done  
date -s "04/14/13"  
for循环创建日志文件  
[root\@lo oldboy]\# find ./ -type f -name "\*.log" -mtime +7\|xargs rm -f
\#删除掉7天的日志  
---  
  
\# 实时监控文件变化  
for n in \`seq 100\`;do sleep 1;echo \$n \>\>/var/log/messages;done  
tail -F /var/log/messages  
tail -F a.log -F删除之后还能监控 -f就不能  
---  
  
\# 显示行号  
[root\@lo oldboy]\# cat -n a.txt  
[root\@lo oldboy]\# vi a.txt 进入输入set un  
[root\@lo oldboy]\# less a.txt  
---  
  
\# 只开启sshd 3级别自启动 其他关闭  
[root\@lo \~]\# chkconfig --list sshd  
sshd 0:off 1:off 2:on 3:on 4:on 5:on 6:off  
[root\@lo \~]\# chkconfig --level 245 sshd off  
[root\@lo \~]\# chkconfig --list sshd  
sshd 0:off 1:off 2:off 3:on 4:off 5:off 6:off  
---  
  
\# /etc/目录为linux系统默认的配置文件及服务启动命令目录  
a）请用tar打包/etc整个目录  
切换到目标目录开始 打包输入当前目录“.”  
[root\@lo etc]\# tar zcvf etc.tar.gz ./etc/  
b）请用tar打包/etc整个目录（打包及压缩，排除/etc/services文件）  
[root\@lo tmp]\# echo oldboy.tar.gz \>\> a.txt  
[root\@lo tmp]\# cat a.txt  
[root\@lo tmp]\# tar zcvfX oldboy.tar.gz a.txt ./oldboy/  
c）请把a点命令的压缩包，解压到/tmp指定目录下  
[root\@lo b]\# tar -zxvf ./a.tar.gz -C ./  
---  
  
\#
如何吧一个外层目录下所有包含oldboy的目录（可能目录的目录里面还有oldboy目录）目录都打包出来---要求解压打包后的目录结构不能改变  
tar -cvzf oldboy.tar.gz \`find . -type d -name oldboy\` 这里的\`是tab上面的
接命令需要这个引号  
tar -cvzf oldboy.tar.gz \`ls -F\|grep /\$\`  
aa/  
ddd/  
tmp/  
tmp/e  
tmp/m  
tmp/f  
---  
  
\# 已知如下命令及其结果：  
[root\@lo tmp]\# echo "i am oldboy,myqq is 49000448"\>\>oldboy.txt  
[root\@lo tmp]\# cat oldboy.txt  
i am oldboy,myqq is 49000448  
现在需要从文件中过滤中“oldboy”和“49000448”字符串，请给出命令。  
[root\@lo tmp]\# awk '{print \$3" "\$6}' oldboy.txt 不加逗号，筛选  
oldboy 49000448  
[root\@lo tmp]\# cut -d" " -f3,6 oldboy.txt -d指定分隔符  
oldboy 49000448  
[root\@lo tmp]\# cut -c 6-11,20- oldboy.txt -c 以字符查看  
oldboy 49000448  
如果需要从文件中过滤“oldboy，49000448”字符串，请再给出命令。  
[root\@lo tmp]\# awk -F '[ ,]' '{print \$3,\$6}' oldboy.txt  
oldboy 49000448 -F '[ ,]' 指定多个分割符空格和逗号都是分隔符  
[root\@lo \~]\# echo ---1:----2\|awk -F'[-:]+' '{print \$2}'  
1  
[root\@lo \~]\# echo ---1:----2\|awk -F'[-:]+' '{print \$3}'  
2  
---  
  
\# 如何查看/etc/services文件的有多少行  
a) wc -l直接查看文件行数  
[root\@lo tmp]\# wc -l /etc/services  
10774 /etc/services  
b) cat 所有查行号都可以用  
[root\@lo tmp]\# cat -n /etc/services\|tail -1  
10774 iqobject 48619/udp \# iqobject  
c)  
[root\@lo tmp]\# sed -n '\$=' /etc/services  
10774  
d)  
[root\@lo tmp]\# awk '{print NR}' /etc/services \|tail -1  
10774  
e)  
[root\@lo tmp]\# grep -n \$ /etc/services \|tail -1  
10774:iqobject 48619/udp \# iqobject  
---  
  
\# 过滤/etc/services 文件包含3306或者1521两数字的行的内容。  
[root\@lo tmp]\# egrep "3306\|1521" /etc/services  
[root\@lo tmp]\# grep -E "3306\|1521" /etc/services \#双引号  
[root\@lo tmp]\# grep -E '3306\|1521' /etc/services \#单引号  
---  
  
\# 使用正则表达式筛选网卡里面的IP地址。  
[root\@lo \~]\# ifconfig eth0\|sed -n '/inet addr/p'\|sed
's\#\^.\*addr:\#\#g'\|awk '{print \$1}'  
192.168.30.129  
表示以任意开头以addr结尾替换  
[root\@lo \~]\# ifconfig eth0\|sed -n 's\#\^.\*addr:\\(.\*\\)
Bcast.\*\$\#\\1\#gp'  
192.168.30.129  
-n 取消默认输出  
\^.\*addr:\\(.\*\\) Bcast.\* 选取要替换的内容  
\\1 \\2 \\3 表示调用()第一个位置 第二个位置 第三个位置  
p 表示打印  
[root\@lo \~]\# ifconfig\|sed -n 's\#\^.\*dr:\\([0-9].\*\\) Bcast:\\([0-9].\*\\)
Ma.\*\#\\1\\2\#gp'  
192.168.30.129 192.168.30.255  
用awk过滤IP地址  
[root\@centos6 \~]\# ifconfig eth0 \|grep 'inet addr' \|awk -F '[: ]+' '{print
\$4}'  
10.1.21.32  
---  
  
\# etiantian取字符  
[root\@lo \~]\# stat /etiantian 取0644\|644  
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)  
[root\@lo \~]\# stat /etiantian\|sed -n 's\#\^.\*s:
(\\([0-9].\*\\)/-r.\*\$\#\\1\#gp'  
0644  
---  
  
\# 直接用stat /etiantian取 取一个文件的权限  
[root\@lo \~]\# stat -c %a /etiantian  
644  
---  
  
\# 查找最近三分钟的文件  
find ./ -type f -name "\*.jpg" -mmin -3  
---  
  
\# 取IP  
ifconfig \|sed -n '2p' \|sed 's/\^.\*inet //g' \|sed 's/ net.\*\$//g' \#
适用centos7  
192.168.21.70  
ifconfig \|sed -n '2p' \|awk -F'[: ]+' '{print \$4}' \# 使用centos6  
192.168.21.70  
---  
  
\#取文件20-30行  
seq 100 \> qwe.txt  
cat qwe.txt \|awk '{if(NR\>19 && NR\<31)print \$0}' \#等价于下面  
cat qwe.txt \|awk 'NR\>=20 && NR\<=30{print \$0}' \#NR取列 大于等于20列
小于等于30列打印  
cat qwe.txt \|head -30 \|tail -11 \#先取头30个在取尾11个  
cat qwe.txt \|sed -n '20,30'p \#-n是取消默认输出 p是打印的意思  
cat qwe.txt \|grep 20 -A 10 \#-A匹配一行后 并显示之后的N行  
---  
  
\#显示行号  
echo gsdf{1..20} \|xargs -n 1 \> qwe.txt \#用管道新增文件  
[root\@linux7 \~]\# cat -n qwe.txt  
---  
  
\#把ip赋值给一个变量 替换到文件里去  
ip=\`ifconfig \| sed -n '2p' \|sed -nr 's/.\*r:(.\*) B.\*/\\1/gp'\`
\#查询IP地址赋值给ip  
cat zhushu \|sed "s/hello world/\$ip/g" \#将IP替换到文件中 可以将变量用cat
zhushu \|sed 's/hello world/'\$ip'/g'  
---  
  
\#删除文件每行第一个字符  
cat ssd \|sed 's/\^.//g' \#换成\$替换每行最后一个  
cat ssd \|sed -r 's/\^.(.)/\\1/g' \#替换每行第2个 .表示一个字符  
cat ssd \| sed 's/.../& /g' \#添加空格 每隔3个添加一个空格  
---  
  
\#查找当前目录下7天前的文件 删除  
find ./ -type f -name "\*.\*" -mtime +7 \|xargs rm  
---  
  
\#fork炸弹 :(){:\|:\&};:  
\#!/bin/bash  
  
:()  
{  
:\|:&  
}  
:  
---  
  
\#批量修改文件名html修改为jpg  
\#!/bin/bash  
for i in \`ls \*.html\`  
do  
name=\`echo \$i\|sed 's/html/jpg/g'\`  
cp \$i \$name  
done  
---  
  
\# 批量修改文件后缀名  
for file in \$(find . -name "\*.txt" -type f); do mv "\$file"
"\${file%.\*}.dat"; done  
---

\#将所有后缀为.c的文件修改为.cpp  
rename .c .cpp \*.c

\---

1、查看有多少个IP访问：

awk '{print \$1}' log_file\|sort\|uniq\|wc -l

2、查看某一个页面被访问的次数：

grep "/index.php" log_file \| wc -l

3、查看每一个IP访问了多少个页面：

awk '{++S[\$1]} END {for (a in S) print a,S[a]}' log_file \> log.txt

sort -n -t ' ' -k 2 log.txt 配合sort进一步排序

4、将每个IP访问的页面数进行从小到大排序：

awk '{++S[\$1]} END {for (a in S) print S[a],a}' log_file \| sort -n

5、查看某一个IP访问了哪些页面：

grep \^111.111.111.111 log_file\| awk '{print \$1,\$7}'

6、去掉搜索引擎统计的页面：

awk '{print \$12,\$1}' log_file \| grep \^"Mozilla \| awk '{print \$2}' \|sort
\| uniq \| wc -l

7、查看2015年8月16日14时这一个小时内有多少IP访问:

awk '{print \$4,\$1}' log_file \| grep 16/Aug/2015:14 \| awk '{print \$2}'\|
sort \| uniq \| wc -l

8、查看访问前十个ip地址

awk '{print \$1}' \|sort\|uniq -c\|sort -nr \|head -10 access_log

uniq -c 相当于分组统计并把统计数放在最前面

cat access.log\|awk '{print \$1}'\|sort\|uniq -c\|sort -nr\|head -10

cat access.log\|awk '{counts[\$(11)]+=1}; END {for(url in counts) print
counts[url], url}

9、访问次数最多的10个文件或页面

cat log_file\|awk '{print \$11}'\|sort\|uniq -c\|sort -nr \| head -10

cat log_file\|awk '{print \$11}'\|sort\|uniq -c\|sort -nr\|head -20

awk '{print \$1}' log_file \|sort -n -r \|uniq -c \| sort -n -r \| head -20

访问量最大的前20个ip

10、通过子域名访问次数，依据referer来计算，稍有不准

cat access.log \| awk '{print \$11}' \| sed -e ' s/http:////' -e ' s//.\*//' \|
sort \| uniq -c \| sort -rn \| head -20

11、列出传输大小最大的几个文件

cat www.access.log \|awk '(\$7\~/.php/){print \$10 " " \$1 " " \$4 " "
\$7}'\|sort -nr\|head -100

12、列出输出大于200000byte(约200kb)的页面以及对应页面发生次数

cat www.access.log \|awk '(\$10 \> 200000 && \$7\~/.php/){print \$7}'\|sort
-n\|uniq -c\|sort -nr\|head -100

13、如果日志最后一列记录的是页面文件传输时间，则有列出到客户端最耗时的页面

cat www.access.log \|awk '(\$7\~/.php/){print \$NF " " \$1 " " \$4 " "
\$7}'\|sort -nr\|head -100

14、列出最最耗时的页面(超过60秒的)的以及对应页面发生次数

cat www.access.log \|awk '(\$NF \> 60 && \$7\~/.php/){print \$7}'\|sort -n\|uniq
-c\|sort -nr\|head -100

15、列出传输时间超过 30 秒的文件

cat www.access.log \|awk '(\$NF \> 30){print \$7}'\|sort -n\|uniq -c\|sort
-nr\|head -20

16、列出当前服务器每一进程运行的数量，倒序排列

ps -ef \| awk -F ' ' '{print \$8 " " \$9}' \|sort \| uniq -c \|sort -nr \|head
-20

17、查看apache当前并发访问数

对比httpd.conf中MaxClients的数字差距多少

netstat -an \| grep ESTABLISHED \| wc -l

18、可以使用如下参数查看数据

ps -ef\|grep httpd\|wc -l

1388

统计httpd进程数，连个请求会启动一个进程，使用于Apache服务器。

表示Apache能够处理1388个并发请求，这个值Apache可根据负载情况自动调整

netstat -nat\|grep -i "80"\|wc -l

4341

shell 在手分析服务器日志不愁

netstat -an会打印系统当前网络链接状态，而grep -i
"80"是用来提取与80端口有关的连接的，wc -l进行连接数统计。

最终返回的数字就是当前所有80端口的请求总数

netstat -na\|grep ESTABLISHED\|wc -l

376

netstat -an会打印系统当前网络链接状态，而grep ESTABLISHED
提取出已建立连接的信息。 然后wc -l统计

最终返回的数字就是当前所有80端口的已建立连接的总数。

netstat -nat\|\|grep ESTABLISHED\|wc

可查看所有建立连接的详细记录

19、输出每个ip的连接数，以及总的各个状态的连接数

netstat -n \| awk '/\^tcp/
{n=split(\$(NF-1),array,":");if(n\<=2)++S[array[(1)]];else++S[array[(4)]];++s[\$NF];++N}
END {for(a in S){printf("%-20s %s ", a, S[a]);++I}printf("%-20s %s
","TOTAL_IP",I);for(a in s) printf("%-20s %s ",a, s[a]);printf("%-20s %s
","TOTAL_LINK",N);}'

20、其他的收集

分析日志文件下 2012-05-04 访问页面最高 的前20个 URL 并排序

cat access.log \|grep '04/May/2012'\| awk '{print \$11}'\|sort\|uniq -c\|sort
-nr\|head -20

查询受访问页面的URL地址中 含有 www.abc.com 网址的 IP 地址

cat access_log \| awk '(\$11\~/www.abc.com/){print \$1}'\|sort\|uniq -c\|sort
-nr

获取访问最高的10个IP地址 同时也可以按时间来查询

cat linewow-access.log\|awk '{print \$1}'\|sort\|uniq -c\|sort -nr\|head -10

时间段查询日志时间段的情况

cat log_file \| egrep '15/Aug/2015\|16/Aug/2015' \|awk '{print \$1}'\|sort\|uniq
-c\|sort -nr\|head -10

分析2015/8/15 到 2015/8/16
访问"/index.php?g=Member&m=Public&a=sendValidCode"的IP倒序排列

cat log_file \| egrep '15/Aug/2015\|16/Aug/2015' \| awk '{if(\$7 ==
"/index.php?g=Member&m=Public&a=sendValidCode") print \$1,\$7}'\|sort\|uniq
-c\|sort -nr

(\$7\~/.php/) \$7里面包含.php的就输出,本句的意思是最耗时的一百个PHP页面

cat log_file \|awk '(\$7\~/.php/){print \$NF " " \$1 " " \$4 " " \$7}'\|sort
-nr\|head -100

列出最最耗时的页面(超过60秒的)的以及对应页面发生次数

cat access.log \|awk '(\$NF \> 60 && \$7\~/.php/){print \$7}'\|sort -n\|uniq
-c\|sort -nr\|head -100

统计网站流量（G)

cat access.log \|awk '{sum+=\$10} END {print sum/1024/1024/1024}'

统计404的连接

awk '(\$9 \~/404/)' access.log \| awk '{print \$9,\$7}' \| sort

统计http status

cat access.log \|awk '{counts[\$(9)]+=1}; END {for(code in counts) print code,
counts[code]}'

cat access.log \|awk '{print \$9}'\|sort\|uniq -c\|sort -rn

每秒并发

watch "awk '{if(\$9\~/200\|30\|404/)COUNT[\$4]++}END{for( a in COUNT) print
a,COUNT[a]}' log_file\|sort -k 2 -nr\|head -n10"

带宽统计

cat apache.log \|awk '{if(\$7\~/GET/) count++}END{print "client_request="count}'

cat apache.log \|awk '{BYTE+=\$11}END{print "client_kbyte_out="BYTE/1024"KB"}'

找出某天访问次数最多的10个IP

cat /tmp/access.log \| grep "20/Mar/2011" \|awk '{print \$3}'\|sort \|uniq
-c\|sort -nr\|head

当天ip连接数最高的ip都在干些什么

cat access.log \| grep "10.0.21.17" \| awk '{print \$8}' \| sort \| uniq -c \|
sort -nr \| head -n 10

小时单位里ip连接数最多的10个时段

awk -vFS="[:]" '{gsub("-.\*","",\$1);num[\$2" "\$1]++}END{for(i in num)print
i,num[i]}' log_file \| sort -n -k 3 -r \| head -10

找出访问次数最多的几个分钟

awk '{print \$1}' access.log \| grep "20/Mar/2011" \|cut -c 14-18\|sort\|uniq
-c\|sort -nr\|head

取5分钟日志

if [ \$DATE_MINUTE != \$DATE_END_MINUTE ] ;then
\#则判断开始时间戳与结束时间戳是否相等

START_LINE=sed -n "/\$DATE_MINUTE/=" \$APACHE_LOG\|head -n1
\#如果不相等，则取出开始时间戳的行号，与结束时间戳的行号

查看tcp的链接状态

netstat -nat \|awk '{print \$6}'\|sort\|uniq -c\|sort -rn

netstat -n \| awk '/\^tcp/ {++S[\$NF]};END {for(a in S) print a, S[a]}'

netstat -n \| awk '/\^tcp/ {++state[\$NF]}; END {for(key in state) print key,"
",state[key]}'

netstat -n \| awk '/\^tcp/ {++arr[\$NF]};END {for(k in arr) print k," ",arr[k]}'

netstat -n \|awk '/\^tcp/ {print \$NF}'\|sort\|uniq -c\|sort -rn

netstat -ant \| awk '{print \$NF}' \| grep -v '[a-z]' \| sort \| uniq -c

netstat -ant\|awk '/ip:80/{split(\$5,ip,":");++S[ip[1]]}END{for (a in S) print
S[a],a}' \|sort -n

netstat -ant\|awk '/:80/{split(\$5,ip,":");++S[ip[1]]}END{for (a in S) print
S[a],a}' \|sort -rn\|head -n 10

awk 'BEGIN{printf ("http_code count_num

")}{COUNT[\$10]++}END{for (a in COUNT) printf a" "COUNT[a]"

"}'

shell 在手分析服务器日志不愁

查找请求数前20个IP（常用于查找攻来源）：

netstat -anlp\|grep 80\|grep tcp\|awk '{print \$5}'\|awk -F: '{print
\$1}'\|sort\|uniq -c\|sort -nr\|head -n20

netstat -ant \|awk '/:80/{split(\$5,ip,":");++A[ip[1]]}END{for(i in A) print
A[i],i}' \|sort -rn\|head -n20

用tcpdump嗅探80端口的访问看看谁最高

tcpdump -i eth0 -tnn dst port 80 -c 1000 \| awk -F"." '{print
\$1"."\$2"."\$3"."\$4}' \| sort \| uniq -c \| sort -nr \|head -20

查找较多time_wait连接

netstat -n\|grep TIME_WAIT\|awk '{print \$5}'\|sort\|uniq -c\|sort -rn\|head
-n20

找查较多的SYN连接

netstat -an \| grep SYN \| awk '{print \$5}' \| awk -F: '{print \$1}' \| sort \|
uniq -c \| sort -nr \| more

根据端口列进程

netstat -ntlp \| grep 80 \| awk '{print \$7}' \| cut -d/ -f1

查看了连接数和当前的连接数

netstat -ant \| grep \$ip:80 \| wc -l

netstat -ant \| grep \$ip:80 \| grep EST \| wc -l

查看IP访问次数

netstat -nat\|grep ":80"\|awk '{print \$5}' \|awk -F: '{print \$1}' \| sort\|
uniq -c\|sort -n

Linux命令分析当前的链接状况

netstat -n \| awk '/\^tcp/ {++S[\$NF]} END {for(a in S) print a, S[a]}'

watch "netstat -n \| awk '/\^tcp/ {++S[\$NF]} END {for(a in S) print a, S[a]}'"
\# 通过watch可以一直监控

LAST_ACK 5
\#关闭一个TCP连接需要从两个方向上分别进行关闭，双方都是通过发送FIN来表示单方向数据的关闭，当通信双方发送了最后一个FIN的时候，发送方此时处于LAST_ACK状态，当发送方收到对方的确认（Fin的Ack确认）后才真正关闭整个TCP连接；

SYN_RECV 30 \# 表示正在等待处理的请求数；

ESTABLISHED 1597 \# 表示正常数据传输状态；

FIN_WAIT1 51 \# 表示server端主动要求关闭tcp连接；

FIN_WAIT2 504 \# 表示客户端中断连接；

TIME_WAIT 1057 \# 表示处理完毕，等待超时结束的请求数；
