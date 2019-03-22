\---  
https://www.cnblogs.com/weifeng1463/p/8757740.html  
https://www.cnblogs.com/luyaran/p/8945426.html  
https://www.jb51.net/article/52893.htm

shell的if和else  
基本语法  
运算符  
-eq =  
-ne !=  
-lt \<  
-le \<=  
-gt \>  
-ge \>=  
-d 目录 如果 filename 为目录，则为真 [ -d /tmp/mydir ]  
-e 文件是否存在 如果 filename 存在，则为真 [ -e /var/log/syslog ]  
-f 文件是否是普通文件（不是目录、设备文件、链接文件）如果 filename
为常规文件，则为真 [ -f /usr/bin/grep ]  
-L 符号链接 如果 filename 为符号链接，则为真 [ -L /usr/bin/grep ]  
-r\|-w\|-x 表示文件是否有可读、可写、可执行权限（指运行这个测试 命令的用户）  
-n string 判断字符串长度非零  
-z string 判断字符串长度为零  
\|\| 或 前边命令失败执行后边的命令  
&& 与 前边命令成功后运行后边命令  
! 表示取反  
  
f1 -nt f2 f1是否比f2新（new than）  
f1 -ot f2 f1是否比f2旧（old than）  
f1 -ef f2 f1和f2是否是相同文件的硬链接  
  
文件类型  
-b 表示是块设备(光驱、软盘等)  
-c 表示是字符设备（键盘、声卡等)  
-p 表示是管道  
-h 表示是符号链接  
-s 表示文件大小不为0  
-S 表示是否是socket  
-z 值  
  
---  
  
if语句用法  
if [条件1]  
then 动作1  
fi  
双分支结构  
if [条件1]  
then 动作1  
else  
动作2  
fi  
多分支结构  
if [条件1]  
then 动作1  
elif [条件2]  
then 动作2  
…………、  
else  
动作n  
fi  
  
elif判断用法  
多重判断 如果 \$1=0 打印0 或者 \$1=1 打印1 否则 打印错误  
\#!/bin/bash  
if [[ \$1 = 0 ]];then  
echo "0"  
elif [[ \$1 = 1 ]];then  
echo "1"  
else  
echo "错误"  
fi  
判断条件1是否为真，如果为真，执行语句1，如果为假，判断条件2，若条件2为真，执行语句1.。。。若所有条件都为假，执行语句n  
---  
  
next用法  
用来跳代码用的  
如果前面条件成立 就跳过下一个条件，如果条件不成立 直接执行下一个条件  
---  
  
多条件判断语法  
shell脚本if判断多个条件  
如果a\>b且a\<c  
if (( a \> b )) && (( a \< c )) 或者if [[ \$a \> \$b ]] && [[ \$a \< \$c ]]
或者if [ \$a -gt \$b -a \$a -lt \$c ]  
如果a\>b或a\<c  
if (( a \> b )) \|\| (( a \< c )) 或者if [[ \$a \> \$b ]] \|\| [[ \$a \< \$c ]]
或者if [ \$a -gt \$b -o \$a -lt \$c ]  
-o = or  
-a = and  
---  
  
[ ] 内参数  
  
---  
  
位置变量用法  
\$0 文件本身  
\$1 第一个参数  
\$2 第二个参数  
\$\# 一共有几个参数  
\$\@ 所有参数  
---  
  
\#比较两个数 如果真 echo 0 否则 echo 1  
[ 2 -ne 10 ] && echo 0 \|\| echo 1  
0  
等价于  
[[ 2 != 10 ]] && echo 0 \|\| echo 1  
0  
---  
  
比较字符串  
vat=dashazi  
[[ \$vat = "dashazi" ]] && echo 0 \|\| echo 1  
0  
[[ \$vat = "dashazi1" ]] && echo 0 \|\| echo 1  
1  
---  
  
正则判断用法  
[[ \$vat =\~ da..a.i ]] && echo 0 \|\| echo 1  
0  
[[ \$vat =\~ da..a.l ]] && echo 0 \|\| echo 1  
1  
---  
  
判断某个变量是不是空值  
[ -z \$dir ] && echo 0 \|\| echo 1  
除了目录外  
[ ! -z \$dir ] && echo 0 \|\| echo 1  
---  
  
判断文件的可执行权限  
[ -x ./asd.sh ] && echo 0 \|\| echo 1  
---  
  
判断路径  
dir=/root/tmp  
echo "\$dir"  
[ -d \$dir ] && echo 0 \|\| echo 1  
---  
  
定义一个函数判断用法  
einfo1() {  
echo "存在"  
}  
einfo2() {  
echo "不存在"  
}  
dir=/root/tmp  
[ -d \$dir ] && einfo1 \|\| einfo2  
dir=/root  
[ -x \$dir/asd.sh ] && einfo1 \|\| einfo2  
  
---  
  
[ \$\# -ne 1 ] && echo 'need \$1' && exit 1 \#判断如果没有给参数直接退出 exit
1非正常退出 给\$?检查看的  
ip=\$1 \#脚本后面第一个值传给变量ip  
ping -c 2 -w 2 \$ip \>/dev/unll 2\>&1 \#输出信息重定向到空 不输出信息  
[ \$? -eq 0 ] && echo "\$ip is on" \#如果执行结果等于0 就输出  
  
单重判断可以直接用  
[ \$? -eq 0 ] && echo "\$ip is on"
