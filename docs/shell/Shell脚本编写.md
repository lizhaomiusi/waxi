Shell脚本编写

12.21 FTP下载文件

\#!/bin/bash

if [ \$\# -ne 1 ]; then

echo "Usage: \$0 filename"

fi

dir=\$(dirname \$1)

file=\$(basename \$1)

ftp -n -v \<\< EOF \# -n 自动登录

open 192.168.1.10

user admin adminpass

binary \# 设置ftp传输模式为二进制，避免MD5值不同或.tar.gz压缩包格式错误

cd \$dir

get "\$file"

EOF

12.22 输入五个100数之内的字符，统计和、最小和最大

COUNT=1

SUM=0

MIN=0

MAX=100

while [ \$COUNT -le 5 ]; do

read -p "请输入1-10个整数：" INT

if [[ ! \$INT =\~ \^[0-9]+\$ ]]; then

echo "输入必须是整数！"

exit 1

elif [[ \$INT -gt 100 ]]; then

echo "输入必须是100以内！"

exit 1

fi

SUM=\$((\$SUM+\$INT))

[ \$MIN -lt \$INT ] && MIN=\$INT

[ \$MAX -gt \$INT ] && MAX=\$INT

let COUNT++

done

echo "SUM: \$SUM"

echo "MIN: \$MIN"

echo "MAX: \$MAX"

12.23 将结果分别赋值给变量

方法1：

for i in \$(echo "4 5 6"); do

eval a\$i=\$i

done

echo \$a4 \$a5 \$a6

方法2：将位置参数192.168.18.1{1,2}拆分为到每个变量

num=0

for i in \$(eval echo \$\*);do \#eval将{1,2}分解为1 2

let num+=1

eval node\${num}="\$i"

done

echo \$node1 \$node2 \$node3

\# bash a.sh 192.168.18.1{1,2}

192.168.18.11 192.168.18.12

方法3：

arr=(4 5 6)

INDEX1=\$(echo \${arr[0]})

INDEX2=\$(echo \${arr[1]})

INDEX3=\$(echo \${arr[2]})

12.24 批量修改文件名

\# touch article_{1..3}.html

\# ls

article_1.html article_2.html article_3.html

现在想把article改为bbs：

方法1：

for file in \$(ls \*html); do

mv \$file bbs_\${file\#\*_}

\# mv \$file \$(echo \$file \|sed -r 's/.\*(_.\*)/bbs_/')

\# mv \$file \$(echo \$file \|echo bbs_\$(cut -d\_ -f2)

done

方法2：

for file in \$(find . -maxdepth 1 -name "\*html"); do

mv \$file bbs_\${file\#\*_}

done

方法3：

\# rename article bbs \*.html

12.25 统计当前目录中以.html结尾的文件总大小

方法1：

\# find . -name "\*.html" -maxdepth 1 -exec du -b {} ; \|awk
'{sum+=\$1}END{print sum}'

方法2：

for size in \$(ls -l \*.html \|awk '{print \$5}'); do

sum=\$((\$sum+\$size))

done

echo \$sum

递归统计：

\# find . -name "\*.html" -exec du -k {} ; \|awk '{sum+=\$1}END{print sum}'

12.26 扫描主机端口状态

\#!/bin/bash

HOST=\$1

PORT="22 25 80 8080"

for PORT in \$PORT; do

if echo &\>/dev/null \> /dev/tcp/\$HOST/\$PORT; then

echo "\$PORT open"

else

echo "\$PORT close"

fi

done

12.27 Expect实现SSH免交互执行命令

需要先安装expect工具。

expect涉及用法说明：

命令描述

set可以设置超时，也可以设置变量

timeout超时等待时间，默认10s

spawn执行一个命令

expect ""匹配输出的内容

exp_continue继续执行下面匹配

回车

\$argc统计位置参数数量

[lindex \$argv 0]位置参数

puts打印字符串，类似于echo

expect{...}输入多行记录

方法1：EOF标准输出作为expect标准输入

\#!/bin/bash

USER=root

PASS=123.com

IP=192.168.1.120

expect \<\< EOF

set timeout 30

spawn ssh \$USER\@\$IP

expect {

"(yes/no)" {send "yes

"; exp_continue}

"password:" {send "\$PASS

"}

}

expect "\$USER\@\*" {send "\$1

"}

expect "\$USER\@\*" {send "exit

"}

expect eof

EOF

方法2：

\#!/bin/bash

USER=root

PASS=123.com

IP=192.168.1.120

expect -c "

spawn ssh \$USER\@\$IP

expect {

"(yes/no)" {send "yes

"; exp_continue}

"password:" {send "\$PASS

"; exp_continue}

"\$USER\@\*" {send "df -h

exit

"; exp_continue}

}"

方法3：将expect脚本独立出来

login.exp登录文件：

\#!/usr/bin/expect

set ip [lindex \$argv 0]

set user [lindex \$argv 1]

set passwd [lindex \$argv 2]

set cmd [lindex \$argv 3]

if { \$argc != 4 } {

puts "Usage: expect login.exp ip user passwd"

exit 1

}

set timeout 30

spawn ssh \$user\@\$ip

expect {

"(yes/no)" {send "yes

"; exp_continue}

"password:" {send "\$passwd

"}

}

expect "\$user\@\*" {send "\$cmd

"}

expect "\$user\@\*" {send "exit

"}

expect eof

执行命令脚本：

\#!/bin/bash

HOST_INFO=user_info

for ip in \$(awk '{print \$1}' \$HOST_INFO)

do

user=\$(awk -v I="\$ip" 'I==\$1{print \$2}' \$HOST_INFO)

pass=\$(awk -v I="\$ip" 'I==\$1{print \$3}' \$HOST_INFO)

expect login.exp \$ip \$user \$pass \$1

done

SSH连接信息文件：

\# cat user_info

192.168.1.120 root 123456

12.28 批量修改服务器用户密码

旧密码SSH主机信息old_info文件：

\# ip user passwd port

\#--------------------------------------

192.168.18.217 root 123456 22

192.168.18.218 root 123456 22

修改密码脚本：

\#!/bin/bash

OLD_INFO=old_info

NEW_INFO=new_info

for IP in \$(awk '/\^[\^\#]/{print \$1}' \$OLD_INFO); do

USER=\$(awk -v I=\$IP 'I==\$1{print \$2}' \$OLD_INFO)

PASS=\$(awk -v I=\$IP 'I==\$1{print \$3}' \$OLD_INFO)

PORT=\$(awk -v I=\$IP 'I==\$1{print \$4}' \$OLD_INFO)

NEW_PASS=\$(mkpasswd -l 8)

echo "\$IP \$USER \$NEW_PASS \$PORT" \>\> \$NEW_INFO

expect -c "

spawn ssh -p\$PORT \$USER\@\$IP

set timeout 2

expect {

"(yes/no)" {send "yes

";exp_continue}

"password:" {send "\$PASS

";exp_continue}

"\$USER\@\*" {send "echo '\$NEW_PASS' \|passwd --stdin \$USER

exit

";exp_continue}

}"

done

生成新密码new_info文件：

192.168.18.217 root n8wX3mU% 22

192.168.18.218 root c87;ZnnL 22

12.29 打印乘法口诀

方法1：

\# awk 'BEGIN{for(n=0;n++\<9;){for(i=0;i++\<n;)printf i"x"n"="i\*n" ";print
""}}'

方法2：

for ((i=1;i\<=9;i++)); do

for ((j=1;j\<=i;j++)); do

result=\$((\$i\*\$j))

echo -n "\$j\*\$i=\$result "

done

echo

done

12.30 getopts工具完善脚本命令行参数

getopts是一个解析脚本选项参数的工具。

命令格式：getopts optstring name [arg]

初次使用你要注意这几点：

1）脚本位置参数会与optstring中的单个字母逐个匹配，如果匹配到就赋值给name，否则赋值name为问号；

2）optstring中单个字母是一个选项，如果字母后面加冒号，表示该选项后面带参数，参数值并会赋值给OPTARG变量；

3）optstring中第一个是冒号，表示屏蔽系统错误（test.sh: illegal option -- h）；

4）允许把选项放一起，例如-ab

下面写一个打印文件指定行的简单例子，用于引导你思路，扩展你的脚本选项功能：

\#!/bin/bash

while getopts :f:n: option; do

case \$option in

f)

FILE=\$OPTARG

[ ! -f \$FILE ] && echo "\$FILE File not exist!" && exit

;;

n)

sed -n "\${OPTARG}p" \$FILE

;;

?)

echo "Usage: \$0 -f \<file_path\> -n \<line_number\>"

echo "-f, --file specified file"

echo "-n, --line-number print specified line"

exit 1

;;

esac

done
