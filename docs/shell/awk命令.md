awk命令 \# 过滤内容 处理列  
https://www.cnblogs.com/dazhidacheng/p/8030481.html  
http://www.linuxe.cn/post-139.html  
  
语法：  
awk [参数] [动作] [文件]  
awk -option 'pattern' filename  
awk -option '{action}' filename  
awk -option 'pattern {action}' filename  
  
参数：  
-F：在awk中默认的分隔符是空白符，使用-F选项可以自定义分隔符，支持指定多个分隔符，通常还会结合正则表达式的+号  
-f：从指定的配置文件执行awk命令  
-v：使用该选项可以进行变量的定义，每一个“-v”定义一个变量  
\~：进行模糊匹配，如awk -F: '\$5\~/root/{print \$1} /etc/passwd'  
!\~：与\~相反，代表不匹配后面的内容  
&&或者\|\|：逻辑与或者逻辑或  
==：完全匹配，非模糊匹配  
!=：与==取反  
\>=：大于等于，当然也有\<=、\>、\<等用于判断  
  
内置变量  
ARGC 命令行参数个数  
ARGV 命令行参数排列  
ENVIRON 支持队列中系统环境变量的使用  
FILENAME awk浏览的文件名  
FNR 浏览文件的记录数  
FS 设置输入域分隔符，等价于命令行 -F选项  
NF 浏览记录的域的个数 统计有多少列  
NR 已读的记录数  
OFS 输出域分隔符  
ORS 输出记录分隔符  
RS 控制记录分隔符  
  
---  
  
awk(关键字:分析&处理) 一行一行的分析处理 awk '条件类型1{动作1}条件类型2{动作2}'
filename, awk 也可以读取来自前一个指令的 standard input  
相对于sed常常用于一整行处理, awk则比较倾向于一行当中分成数个"字段"(区域)来处理,
默认的分隔符是空格键或tab键  
awk工作模式  
awk和sed一样会把需要处理的文件按行读取到内存中，默认用空白（空格、tab键也被当做空白）作为每个字段的分隔符将内容分割成多个部分，每个字段被依次定义为\$1、\$2、\$3、\$n。而\$0代表了整行内容。  
  
{action}--awk常用操作命令  
在上面的命令格式中{action}指明需要做的动作，最常用的动作就是打印，分别是print和printf（printf可以做格式化，比如左右对齐等），不写action的话默认就是print
\$0，也就是打印该行。我们也可以自己增加需要打印出来的东西，这部分内容需要用引号括起来，否则会被当做变量，下面是print格式化输出的例图：  
  
在进行print操作时可以使用AWK的位置变量，如print
\$1就是显示第一列的内容，也可以同时显示多列，如awk '{print
\$1,\$2}'，（当现实多列数据时，使用逗号会用空格作为默认分隔符，这里可以使用双引号自定义成其他字符作为分隔符，如'{
print \$1"+"\$2）}'）。  
  
printf格式化说明：  
%s 字符类型  
%d 数值类型  
%f 浮点类型  
-表示左对齐，默认是右对齐  
printf不会自动换行，需要加\\n  
awk -F: '{printf "\| %-15s\| %-10s\| %-15s\|\\n",\$1,\$2,\$3}' /etc/passwd  
\| root \| x \| 0 \|  
\| bin \| x \| 1 \|  
  
awk的处理流程是:  
1、读第一行, 将第一行资料填入变量 \$0, \$1... 等变量中  
2、依据条件限制, 执行动作  
3、接下来执行下一行  
所以, AWK一次处理是一行, 而一次中处理的最小单位是一个区域  
另外还有3个变量,  
NF: 每一行处理的字段数  
NR 目前处理到第几行 FS  
目前的分隔符  
逻辑判断 \> \< \>= \<= == !== , 赋值直接使用=  
cat /etc/passwd \| awk '{FS=":"} \$3\<10 {print \$1 "\\t" \$3}'
\#首先定义分隔符为:, 然后判断, 注意看, 判断没有写在{}中, 然后执行动作,
FS=":"这是一个动作, 赋值动作, 不是一个判断, 所以不写在{}中  
BEGIN END \#给程序员一个初始化和收尾的工作,
BEGIN之后列出的操作在{}内将在awk开始扫描输入之前执行, 而END{}内的操作,
将在扫描完输入文件后执行.  
awk '/test/ {print NR}' abc \#将带有test的行的行号打印出来,
注意//之间可以使用正则表达式  
awk {}内, 可以使用 if else ,for(i=0;i\<10;i++), i=1 while(i\<NF)  
可见, awk的很多用法都等同于C语言, 比如"\\t" 分隔符, print的格式, if, while, for
等等  
  
内置变量  
-F \#指定分隔符和多个分隔符  
awk '{print \$1}' ces.txt \# 取列 默认空格分隔符 \$1取第一列..\$2取第二列
..\$(NF-1)..\$NF最后一列  
awk -F ":" '{print \$1" "\$2" "\$3}' /etc/passwd \#-F ":"指定以分隔符 以:为界
默认空格 打印/etc/passwd的第一列第二列第三列  
ifconfig \| grep 'broadcast' \| awk -F ' ' '{print \$2}'
\#指定分隔符为空格取IP地址打印第二列  
ifconfig \| grep 'broadcast' \| awk '{print \$2}' \#因为默认是空格可以  
netstat -n \| grep EST \| awk -F '[ :]+' '{print \$4}'
\#利用正则表达式的+号将连在一起的同一个符号仅当做一个分隔符处理  
cat /etc/passwd \| grep -v 'nologin' \| awk -F ':' '{print \$1}'
\#取不是nologin的用户  
\#同时指定多个分隔符  
cat ces.txt \|awk -F '[: ]' '{print \$2}' \#[: ]指定多个分隔符 或的意思
指定:或者空格为分隔符，打印第二列  
cat ces.txt \|awk -F '[: ]+' '{print \$2}' \#[: ]+号一个或多个 将连续的:或空格
当作一个分隔符处理

\#指定多个字符串为分隔符

awk -F"[01]" '{}' 这种形式指定的分隔符是或的关系，即0或1作为分隔符；

awk -F"[0][1]" '{}'
这种形式指定的分隔符是合并的关系，即以“01”作为一个字符为分隔符。  
\#同时取多个列  
cat /etc/passwd \|awk -F '[:]' '{print \$1,\$2}' \#逗号取多个列  
  
NF \#会记录awk命令所处理的每一行数据有几列字段 取最后一列  
cat ces.txt \|awk '{print NF}' \#计数  
cat ces.txt \|awk '{print \$NF}' \#\$NF表示最后一列  
cat ces.txt \|awk '{print \$(NF-1)}' \#倒数第二列  
  
NR和FNR
\#打印出每一行的行号，不过在处理多个文件时有一点点区别，NR会直接把多个文件的行数依次显示出来，而FNR则对单个文件做行数的显示。  
cat ces.txt \|awk 'NR==3{print \$0}' \#取第三行  
cat ces.txt \|awk 'NR\>1&\<4{print \$0}' \#取行 打印第2，3行  
cat ces.txt \|awk 'NR\>1&\<4{print \$1}' 取第2,3行第一列  
cat ces.txt\|awk 'NR==1{print \$1}NR==2{print \$2}'
\#取第一行第一列和第二行第二列  
  
真或非  
awk 'NR==1{print \$1}' ces.txt \#取第一行  
awk 'NR!=1{print \$1}' ces.txt \#!非的意思 不等于1的时候  
  
变量 0假 1真  
awk '{a=0}a{print \$1}' ces.txt \#0赋值给a 取  
awk '{a=1}a{print \$1}' ces.txt \#1赋值给a 取  
  
BEGIN的意思是执行文件之前先处理 常用给变量赋值  
END的意思是最后执行 处理完之后执行END里面命令  
cat ces.txt \|awk 'BEGIN{print "--------------------HEAD"}{print \$0}END{print
"---------------------END"}'  
--------------------HEAD  
ll sfhsdfhjsdhf 80 89 09  
kk d12305983290 23 23 48  
ll 859712301238 23 09 95  
hj 954972340348 23 52 54  
---------------------END  
  
计算  
cat ces.txt \|awk '{print \$0,\$3+\$4+\$5,(\$3+\$4+\$5)/3}'
\#取所有列和第3,4,5的和与3,4,5平均数  
cat ces.txt \|awk '{a=\$3+\$4+\$5;print \$0,a,a/3}' \#变量3,4,5的和给a 取a的值  
cat ces.txt \|awk '{a=\$3+\$4+\$5;print \$0,a,a/3}'  
cat ces.txt \|awk '{a=\$3+\$4+\$5;print \$0,a,int(a/3)}' \#int取整  
cat 1-10.txt \|awk '{a=a+\$1;print a}' \#1-10相加  
cat 1-10.txt \|awk '{a=a+\$1}END{print a}' \#1-10相加求和 a按顺序加第一列  
cat 1-10.txt \|awk '{a+=\$1}END{print a}' \#等价于a=a+\$1  
cat ces.txt \|awk '{a+=\$NF}END{print a}' \#取最后一列的和  
ps aux \|grep /usr/sbin/ \|awk '{a+=\$4}END{print a}' \#一个实例  
  
if 如果  
cat ces.txt \|awk '{if(\$3\>=80){print \$0}}' \#判断取3列大于等于80  
ll /etc/ \|grep '\^-' \|awk '{if(\$5\<1024){print \$0}}' \#取目录下小于1024文件
'\^-'非目录  
ll /etc/ \|awk '/\^-/{if(\$5\<1024){print \$0}}' \#等价于上面语句  
cat ces.txt \|awk '{if(NR==1){print \$0}}' \#取第一行  
cat ces.txt \|awk '{if(\$3\>=70){print \$0}}' \#第三列\>=70的行  
统计总行数  
cat /etc/passwd \|awk '{n++}END{print n}' \#统计总行数  
  
---

for循环  
cat ces.txt \|awk '{for(i=1;i\<=NF;i++){print \$i}}' \#挨个循环打印  
cat ces.txt \|awk '{for(i=1;i\<=NF;i+=2){printf \$i" "}print xxoo}'
\#循环取奇数列 并排版 printf不换行  
cat ces.txt \|awk '{for(i=2;i\<=NF;i+=2){printf \$i" "}print xxoo}'
\#循环取偶数列  
who \|awk '{a++}END{print a}' \#调用内部变量取最后结果  
  
取两个文件的字段 组成新文件  
[root\@linux7 \~]\# cat zxc \|awk '{print \$2}' \>1  
[root\@linux7 \~]\# cat asd \|awk '{print \$1}' \>2  
[root\@linux7 \~]\# paste 1 2 \#合并为新文件 分隔符为tab  
5324 lx  
603s vd  
6445 vs  
[root\@linux7 \~]\# paste 1 2 \|sed 's/\\t/ /g' \#修改分隔符为空格  
5324 lx  
603s vd  
6445 vs  
  
统计文本的字符  
cat asd \|wc  
3 15 51 \#3行 15个单词 51个字符  
cat asd \|awk '{for(i=1;i\<=NF;i++){n++}}END{print n}' \#用for来统计文本字符  
cat asd \|awk 'END{print NR}' \#取最后一行  
cat asd \|awk '{for(i=1;i\<=NF;i++){if(\$i=="60"){n++}}}END{print n}'  
取IP  
ifconfig ens33 \|awk -F '[ ]+' '/inet /{print \$3}' \#取IP指定分隔符和字段  
ps aux \|awk '/\\/bin/{a+=\$3;b+=\$4}END{print "CPU:"a" bbb:"b}'
\#统计/bin下的CPU的和  
  
统计常用的命令  
history \|awk '{print \$2}'\|sort \|uniq -c \|sort -nr \|head -5 \#取第二列 排序
去重并计数 在排序 在取头  
80 cat  
16 sed  
16 ls  
12 ifconfig  
8 ping

\---  
  
cat ssd \|awk '{\$2="";print \$0}' \#删除第二列  
cat ssd \|awk '{print \$1,\$3,\$4}' \#同上  
  
匹配包含root的行 !\~取反不匹配  
[root\@centos6 \~]\# cat /etc/passwd \|awk -F: '\$1\~/root/ {print \$1}'  
root:x:0:0:root:/root:/bin/bash  
  
[root\@centos6 \~]\# cat /etc/passwd \|awk -F: '\$1!\~/root/ {print \$1}'  
root:x:0:0:root:/root:/bin/bash  
  
\#awk换行输出  
cat ip.lst \| awk -F" " '{printf ("%s ", \$3)}'
