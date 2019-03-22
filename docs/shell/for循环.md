https://www.jianshu.com/p/f973002a7ca2  
https://blog.csdn.net/babyfish13/article/details/52981110  
https://blog.csdn.net/taiyang1987912/article/details/38929069

for循环  
while循环  
  
---  
  
for循环  
for循环一般格式为：  
属于“当型循环”，即“当满足条件的时候执行”。  
  
for 变量 in 常量列表; do 一些命令; done;  
for file in \$(ls); do echo \$file; done  
for i in \`seq 10\`; do echo \$i; done  
  
for (( 变量初始化; 条件判断; 变量自变 )); do 一些命令; done;  
for((i=0; i\<10; i++)); do echo \$i; done

\---  
  
第一种 列表for循环  
for 变量 in 值1 值2 值3 ...  
do  
动作1  
动作2  
... ...  
done

\---  
  
第二种 类C风格的for循环  
for ((设置计数器;测试计数器;增加计数器))  
do  
动作1  
动作2  
... ...  
done  
  
类C风格的for循环  
\#!/bin/bash  
for((i=1;i\<=5;i++));  
do  
echo \$(expr \$i \\\* \$i + 1);  
done  
或者  
  
\#!/bin/bash  
awk 'BEGIN{for(i=1; i\<=5; i++)  
print (i\*i+1)  
}'

\---  
  
while循环  
while 条件  
do  
动作1  
动作2  
... ...  
done  
当while后条件为真的时候，就执行do和done之间的语句，知道条件为假结束  
  
while true  
do  
...  
done  
：shell里叫做空指令，什么也不做  
  
也称为前测试循环语句，重复次数是利用一个条件来控制是否继续重复执行这个语句。为了避免死循环，必须保证循环体中包含循环出口条件即表达式存在退出状态为非0的情况。例如，计算1\~100以内所有的奇数之和：  
\#!/bin/bash  
sum=0  
i=1  
while(( i \<= 100 ))  
do  
let "sum+=i"  
let "i += 2"  
done  
echo "sum=\$sum"

\---  
  
  
while read line循环  
按行读文件 一秒读一行  
while read line  
do  
echo \$line  
sleep 1  
done \< /etc/passwd

\---  
  
列表循环  
selcet 变量 in 命令1 命令2 命令3 ... ...  
do  
都能做  
done  
生成命令列表  
  
select结构从技术角度看不能算是循环结构，只是相似而已，它是bash的扩展结构用于交互式菜单显示，功能类似于case结构，但是比case的交互性要好。在遍历列表功能中，select结构可以实现循环的功能。  
例如，以下选择，只有选择white的时候，退出循环  
\#!/bin/bash  
select color in "red" "blue" "green" "white" "black"  
do  
echo \$color  
done

\---  
  
until循环  
until 条件  
do  
动作1  
动作2  
... ...  
done  
当until后的条件wi假的时候，就执行do 和done之间的语句，直到条件为真结束  
  
until命令和while命令类似，while能实现的功能until也可以实现。但区别是until循环的退出状态是为0（与while刚好相反），即whie循环在条件为真时继续执行循环，而until则在条件为假时执行循环。  
例如，计算1\~100以内所有的奇数之和：  
\#!/bin/bash  
i=1  
sum=0  
until [[ "\$i" -gt 100 ]] \#直到i大于100  
do  
let "sum+=i"  
let "i += 2"  
done  
echo "sum=\$sum"

\---  
  
循环控制符  
continue，break，exit  
  
break 跳出整个循环  
continue 跳出当前循环，不在执行continue后面的语句，进入下一次循环  
exit 会直接退出整个程序  
  
在循环语法中，经常需要根据条件控制循环退出或跳过本次执行，这时候就需要用到循环控制符。循环控制符主要包括两个：break和continue。  
  
break：退出本层循环循环。  
continue：只退出本次循环，仍然执行后继续循环。  
  
\#break跳出死循环 跳出所有  
continue跳死循环 只跳当前一次  
break退出本层循环  
在for、while和until循环中break可强行退出循环。  
注意：break语句仅能退出当前的循环，如果是两层循环嵌套，则需要在外层循环中使用break。  
例如,计算1\~100以内所有的奇数之和：  
\#!/bin/bash  
sum=0  
for (( i=1; i \<= 1000; i+=2))  
do  
if [ "\$i" -lt 100 ]  
then  
let "sum+=i"  
elif [ "\$i" -gt 100 ]  
then  
echo "sum=\$sum"  
break  
fi  
done  
  
continue退出本次循环继续执行下一次循环  
在for、while和until中用于让脚本跳过其后面的语句，执行下一次循环。  
例如，显示10以内能被3整除的正整数。  
\#!/bin/bash  
for (( i=1; i \< 10; i++ ))  
do  
let "tmp=i%3" \#被3整除  
if [ "\$tmp" -ne 0 ]  
then  
continue  
fi  
echo -n "\$i "  
done  
echo ""

\---  
  
循环练习

\---  
  
1、数字循环  
\#!/bin/bash  
for value in {1..5}  
\#for value in 1 2 3 4 5  
do  
echo "Now value is \$value..."  
done

\---  
  
计算1～100内所有的奇数之和。  
\#!/bin/bash  
sum=0  
for i in {1..100..2}  
do  
let "sum+=i"  
done  
echo "sum=\$sum"

\---  
  
\#计算  
\#for循环求35以内的和  
for((i=1;i\<=35;i++));  
do  
sum=\`expr \$sum + \$i\`  
done  
echo \$sum

\---  
  
\#计算1\~5中数字的平方+1  
\#!/bin/bash  
for i in \$(seq 1 5)  
do  
echo \$(expr \$i \\\* \$i + 1);  
done

\---  
  
字符串for循环  
显示参数列表的所有单词  
\#!/bin/bash  
for i in v1 v2 v3  
do  
echo value is: \$i  
done

\---  
  
显示list中的所有单词  
\#!/bin/bash  
list="Earth is the Home of Human! ";  
for i in \$list;  
do  
echo word is \$i;  
done

\---  
  
传入参数列表  
\#!/bin/bash  
  
for i in \$\*  
do  
echo \$i is input value\\! ;  
done

\---

路径查找for循环  
查询当前目录下的文件列表  
\#!/bin/bash  
  
for file in \$( ls )  
do  
echo "file: \$file"  
done

\---  
  
for file in \$( ls )语法的等效语法有很多，如下：  
for file in \`ls\`  
或者  
for file in \*

\---  
  
通配符查找指定路径  
\#!/bin/bash  
for file in /root/\*;  
do  
echo \$file;  
done

\---  
  
通配符查找指定路径下符合指定扩展名的文件路径  
\#!/bin/bash  
  
for file in /root/study/shell/\*.sh;  
do  
echo \$file;  
done  
  
---
